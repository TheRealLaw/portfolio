import ExifReader from 'exifreader';
import fs from 'fs';
import path from 'path';

const convertToDecimal = (gpsTags, refTag) => {
  if (!gpsTags) return null;
  try {
    let decimal = null;
    if (typeof gpsTags.description === 'number') {
      decimal = gpsTags.description;
    } else if (typeof gpsTags.description === 'string' && gpsTags.description.includes(',')) {
      const parts = gpsTags.description.split(',').map(p => parseFloat(p.trim()));
      if (parts.length >= 3 && !isNaN(parts[0])) {
        decimal = parts[0] + (parts[1] || 0) / 60 + (parts[2] || 0) / 3600;
      }
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
      let refStr = "";
      if (Array.isArray(refTag?.value)) {
        refStr = refTag.value[0];
      } else if (refTag?.value) {
        refStr = refTag.value;
      } else if (refTag?.description) {
        refStr = refTag.description;
      }
      
      const refChar = String(refStr).trim().toUpperCase()[0];
      
      if (refChar === 'S' || refChar === 'W') {
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

function findGpsFiles(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            findGpsFiles(fullPath);
        } else if (fullPath.match(/\.(jpg|jpeg|png)$/i)) {
            try {
                const buffer = fs.readFileSync(fullPath);
                const tags = ExifReader.load(buffer);
                if (tags.GPSLatitude) {
                    console.log('---', fullPath, '---');
                    const lat = convertToDecimal(tags.GPSLatitude, tags.GPSLatitudeRef);
                    const lon = convertToDecimal(tags.GPSLongitude, tags.GPSLongitudeRef);
                    console.log('Lat:', lat, 'Ref:', tags.GPSLatitudeRef?.description || tags.GPSLatitudeRef?.value);
                    console.log('Lon:', lon, 'Ref:', tags.GPSLongitudeRef?.description || tags.GPSLongitudeRef?.value);
                }
            } catch (e) {
                // Ignore
            }
        }
    }
}

findGpsFiles('/Users/LeoWuellner/Code/portfolio/src/content/portfolio/Tokyo');
findGpsFiles('/Users/LeoWuellner/Code/portfolio/src/content/portfolio/Kyoto');
