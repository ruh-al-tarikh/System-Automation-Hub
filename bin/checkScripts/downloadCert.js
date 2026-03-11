// downloadCert.js
// Function to download a TLS certificate from a host and save to a file
const fs = require('fs');
const tls = require('tls');
const net = require('net');

async function downloadCert(host, port = 443, outputFile) {
    return new Promise((resolve, reject) => {
        const socket = tls.connect(port, host, {}, () => {
            const cert = socket.getPeerCertificate();
            if (!cert || !cert.raw) {
                return reject(new Error('Unable to retrieve certificate.'));
            }
            // Save PEM encoded certificate
            const pem = `-----BEGIN CERTIFICATE-----\n${cert.raw.toString('base64')}\n-----END CERTIFICATE-----\n`;
            fs.writeFileSync(outputFile, pem);
            socket.end();
            resolve();
        });

        socket.on('error', (err) => reject(err));
    });
}

// Export function
module.exports = downloadCert;