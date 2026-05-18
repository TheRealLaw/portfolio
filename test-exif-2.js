import ExifReader from 'exifreader';
import fs from 'fs';

const filePath = '/Users/LeoWuellner/Code/portfolio/src/content/portfolio/rome/Contrast .jpeg';
const fileBuffer = fs.readFileSync(filePath);
const tags = ExifReader.load(fileBuffer);

const convertToDecimal = (gpsTags, refTag) => {
  if (!gpsTags) return null;
  try {
    let decimal = null;
    
    // 1. If description is already a number (ExifReader often does this)
    if (typeof gpsTags.description === 'number') {
      decimal = gpsTags.description;
    }
    // 2. Try parsing from description string (if it's a formatted string)
    else if (typeof gpsTags.description === 'string' && gpsTags.description.includes(',')) {
      const parts = gpsTags.description.split(',').map(p => parseFloat(p.trim()));
      if (parts.length >= 3 && !isNaN(parts[0])) {
        decimal = parts[0] + (parts[1] || 0) / 60 + (parts[2] || 0) / 3600;
      }
    }
    // 3. Try processing from raw value array
    else if (Array.isArray(gpsTags.value) && gpsTags.value.length >= 3) {
      const dms = gpsTags.value;
      const toNum = (v) => {
        if (typeof v === 'number') return v;
        if (Array.isArray(v) && v.length === 2) {
          return v[1] === 0 ? 0 : v[0] / v[1]; // Handle [num, den]
        }
        if (v && typeof v === 'object' && 'numerator' in v && 'denominator' in v) {
          return v.denominator === 0 ? 0 : v.numerator / v.denominator;
        }
        return parseFloat(String(v));
      };

      const deg = toNum(dms[0]);
      const min = toNum(dms[1]);
      const sec = toNum(dms[2]);
      decimal = deg + min / 60 + sec / 3600;
    }

    if (decimal !== null && !isNaN(decimal)) {
      const ref = (refTag?.description || (Array.isArray(refTag?.value) ? refTag.value[0] : refTag?.value) || "").toString().toUpperCase();
      if (ref.includes("S") || ref.includes("W")) {
        decimal *= -1;
      }
      return decimal.toFixed(6);
    }
  } catch (e) {
    console.warn("GPS Conversion Error:", e);
  }
  return null;
};

console.log('Lat:', convertToDecimal(tags.GPSLatitude, tags.GPSLatitudeRef));
console.log('Lon:', convertToDecimal(tags.GPSLongitude, tags.GPSLongitudeRef));
