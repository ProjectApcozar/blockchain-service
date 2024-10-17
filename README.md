# blockchain-service
LOCALHOST:
npm install

1. Compilar contrato:
$ npx hardhat compile

2. Iniciar nodo local hardhat:
npx hardhat node

3. Desplegar contrato:
npx hardhat ignition deploy ./ignition/modules/MedicalDataAccess.js --network localhost
4. Setear private key y dirección del contrato desplegado en service.js y:
node service.js
