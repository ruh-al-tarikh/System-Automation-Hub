// runDownloadCert.js
// Script to run the certificate download and handle backups
const fs = require('fs');
const path = require('path');
const downloadCert = require('./downloadCert');

// Output certificate path
const OUTPUT_FILE = path.resolve(__dirname, 'download_ca_cert.pem');

(async () => {
    try {
        // Backup existing certs
        if (fs.existsSync(OUTPUT_FILE)) {
            const backupFile = `${OUTPUT_FILE}.${Date.now()}.bak`;
            fs.renameSync(OUTPUT_FILE, backupFile);
            console.log(`Existing certificate backed up as ${backupFile}`);
        }

        // Download from github.com
        await downloadCert('github.com', 443, OUTPUT_FILE);
        console.log(`Certificate successfully saved to ${OUTPUT_FILE}`);
    } catch (err) {
        console.error('Error downloading certificate:', err);
        process.exit(1); // Fail workflow if download fails
    }
})();