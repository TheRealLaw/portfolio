import ExifReader from 'exifreader';
import fs from 'fs';

const filePath = '/Users/LeoWuellner/Code/portfolio/src/content/portfolio/rome/Contrast .jpeg';
const fileBuffer = fs.readFileSync(filePath);
const tags = ExifReader.load(fileBuffer);
console.log('GPSLongitudeRef:', tags.GPSLongitudeRef);
