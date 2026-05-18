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
                    const rawLat = tags.GPSLatitude.value;
                    const rawLon = tags.GPSLongitude.value;
                    if (Array.isArray(rawLat) && Array.isArray(rawLon)) {
                        const latD = rawLat[0] ? rawLat[0][0] : 0;
                        const latM = rawLat[1] ? rawLat[1][0] : 0;
                        const latS = rawLat[2] ? rawLat[2][0] : 0;
                        const lonD = rawLon[0] ? rawLon[0][0] : 0;
                        const lonM = rawLon[1] ? rawLon[1][0] : 0;
                        const lonS = rawLon[2] ? rawLon[2][0] : 0;
                        if (latD === 35 && latM === 23 && latS === 41) {
                            console.log('FOUND:', fullPath);
                        }
                        if (lonD === 139 && lonM === 9 && lonS === 8) {
                            console.log('FOUND:', fullPath);
                        }
                    }
                }
            } catch (e) {}
        }
    }
}

findGpsFiles('/Users/LeoWuellner/Code/portfolio/src/content/portfolio');
