// runDownloadCert.js
const fs = require('fs');
const path = require('path');
const { downloadCert } = require('./downloadCert');

// File where the certificate will be saved
const OUTPUT_FILE = './download_ca_cert.pem';

(async () => {
    try {
        // Check if the file already exists
        if (fs.existsSync(OUTPUT_FILE)) {
            console.log(`${OUTPUT_FILE} already exists. Backing it up.`);
            const backupFile = `${OUTPUT_FILE}.${Date.now()}.bak`;
            fs.renameSync(OUTPUT_FILE, backupFile);
            console.log(`Existing file backed up as ${backupFile}`);
        }

        // Download certificate
        await downloadCert('github.com', 443, OUTPUT_FILE);
        console.log('Certificate download complete.');
    } catch (err) {
        console.error('Error:', err);
    }
})();