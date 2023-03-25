const { format } = require("mysql");

const dateTimeConverter = (dateTime) => {
    if (dateTime){
    const dateObj = new Date(dateTime);
    const month = dateObj.getMonth() + 1;
    const day = dateObj.getDate();
    const year = dateObj.getFullYear();
    const hours = dateObj.getHours();
    const minutes = dateObj.getMinutes()
    const seconds = dateObj.getSeconds();
    const newDate = `${day}/${month}/${year} ${hours}:${minutes}:${seconds}`;
    return newDate;
    }
    else return null;
};

exports.dateTimeConverter = dateTimeConverter;