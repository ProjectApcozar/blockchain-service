// service.js
const express = require('express');
const ethers = require('ethers');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(bodyParser.json());

// Configuración del proveedor y la billetera
// Conectarse al nodo local de Hardhat
const provider = new ethers.JsonRpcProvider('http://localhost:8545');

// Usar una cuenta generada por Hardhat (reemplaza con una clave privada de tu nodo local)
const privateKey = "0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e";
const wallet = new ethers.Wallet(privateKey, provider);

// Obtener el ABI y la dirección del contrato desde los artefactos de Hardhat
const contractArtifact = JSON.parse(
    fs.readFileSync(
        path.join(__dirname, 'artifacts', 'contracts', 'MedicalDataAccess.sol', 'MedicalDataAccess.json'),
        'utf8'
    )
);
const contractABI = contractArtifact.abi;

// Si usaste Hardhat para desplegar, puedes obtener la dirección del contrato de los archivos de despliegue o configurarla manualmente
const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'; // Reemplaza con la dirección de tu contrato desplegado

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

// Endpoint para registrar un paciente
app.post('/registerPatient', async (req, res) => {
    try {
        const tx = await contract.registerPatient();
        await tx.wait();
        res.json({ message: 'Paciente registrado exitosamente', transactionHash: tx.hash });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para registrar un doctor
app.post('/registerDoctor', async (req, res) => {
    const { doctorAddress } = req.body;
    try {
        const tx = await contract.registerDoctor(doctorAddress);
        await tx.wait();
        res.json({ message: 'Doctor registrado exitosamente', transactionHash: tx.hash });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para autorizar a un doctor
app.post('/authorizeDoctor', async (req, res) => {
    const { doctorAddress } = req.body;
    try {
        const tx = await contract.authorizeDoctor(doctorAddress);
        await tx.wait();
        res.json({ message: 'Doctor autorizado exitosamente', transactionHash: tx.hash });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para revocar la autorización de un doctor
app.post('/revokeDoctorAuthorization', async (req, res) => {
    const { doctorAddress } = req.body;
    try {
        const tx = await contract.revokeDoctorAuthorization(doctorAddress);
        await tx.wait();
        res.json({ message: 'Autorización revocada exitosamente', transactionHash: tx.hash });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para verificar si una dirección es paciente
app.get('/isPatient/:address', async (req, res) => {
    const { address } = req.params;
    try {
        const result = await contract.isPatient(address);
        res.json({ isPatient: result });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para verificar si una dirección es doctor
app.get('/isDoctor/:address', async (req, res) => {
    const { address } = req.params;
    try {
        const result = await contract.isDoctor(address);
        res.json({ isDoctor: result });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para verificar si un doctor está autorizado por un paciente
app.get('/isDoctorAuthorized/:patientAddress/:doctorAddress', async (req, res) => {
    const { patientAddress, doctorAddress } = req.params;
    try {
        const result = await contract.isDoctorAuthorized(patientAddress, doctorAddress);
        res.json({ isAuthorized: result });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Iniciar el servidor
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
});
