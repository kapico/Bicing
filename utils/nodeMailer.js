const nodemailer = require("nodemailer");

function nodeMailer(from, to, subject, html) {

    return new Promise((resolve, reject) => {

        const transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: "ifcd0112cief@gmail.com",
                pass: "ewngnkeadlsdrnzo"
            },
        });

        const mailOptions = {
            from: from,
            to: to,
            subject: subject,
            html: html
        }

        transporter.sendMail(mailOptions, error => {
            if (error) {
                reject(error);
            } else {
                resolve("Mensaje enviado correctamente!");
            }
        });

    });
}

exports.nodeMailer = nodeMailer;