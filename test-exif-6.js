import ExifReader from 'exifreader';
import fs from 'fs';
import path from 'path';

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
                    const raw = tags.GPSLongitude.value;
                    if (Array.isArray(raw)) {
                        console.log(fullPath);
                        console.log(JSON.stringify(raw));
                    }
                }
            } catch (e) {}
        }
    }
}

findGpsFiles('/Users/LeoWuellner/Code/portfolio/src/content/portfolio');
