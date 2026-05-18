import ExifReader from 'exifreader';
import fs from 'fs';

const files = [
  '/Users/LeoWuellner/Code/portfolio/src/content/portfolio/rome/Contrast .jpeg',
  '/Users/LeoWuellner/Code/portfolio/src/content/portfolio/new york/IMG_1885.jpeg'
];

const convertToDecimal = (gpsTags, refTag) => {
  if (!gpsTags) return null;
  try {
    let decimal = null;
    
    if (typeof gpsTags.description === 'number') {
      decimal = gpsTags.description;
    } else if (Array.isArray(gpsTags.value) && gpsTags.value.length >= 3) {
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
      // Get the first character of the raw value (usually "N", "S", "E", "W")
      let refStr = "";
      if (Array.isArray(refTag?.value)) {
        refStr = refTag.value[0];
      } else if (refTag?.value) {
        refStr = refTag.value;
      } else if (refTag?.description) {
        refStr = refTag.description; // fallback to description like "East longitude"
      }
      
      const refChar = String(refStr).trim().toUpperCase()[0];
      
      // Only negate if we strictly match S or W
      if (refChar === 'S' || refChar === 'W') {
        // Just in case decimal is already negative, use Math.abs
        decimal = -Math.abs(decimal);
      } else if (refChar === 'N' || refChar === 'E') {
        decimal = Math.abs(decimal);
      }
      return decimal.toFixed(6);
    }
  } catch (e) {
    console.warn("GPS Conversion Error:", e);
  }
  return null;
};

for (const filePath of files) {
  const fileBuffer = fs.readFileSync(filePath);
  const tags = ExifReader.load(fileBuffer);
  console.log('---', filePath, '---');
  console.log('Lat:', convertToDecimal(tags.GPSLatitude, tags.GPSLatitudeRef));
  console.log('Lon:', convertToDecimal(tags.GPSLongitude, tags.GPSLongitudeRef));
}
