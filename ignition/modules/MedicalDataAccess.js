const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("MedicalDataAccessModule", (m) => {
    const medicalDataAccess = m.contract("MedicalDataAccess");

    return { medicalDataAccess };
})