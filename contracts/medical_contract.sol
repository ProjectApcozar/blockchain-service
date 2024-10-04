// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalDataAccess {

    struct Patient {
        address patientAddress;
    }

    mapping(address => Patient) private patients;
    mapping(address => string[]) private patientToURIs;
    mapping(address => address[]) private patientToAuthorizedDoctors;

    event AccessGranted(address indexed patient, address indexed doctor);
    event AccessRevoked(address indexed patient, address indexed doctor);
    event DataAdded(address indexed patient, string dataURI);

    function registerPatient() public {
        require(patients[msg.sender].patientAddress == address(0), "Patient already registered");
        patients[msg.sender].patientAddress = msg.sender;
    }

    function addData(string calldata _dataURI) public {
        require(patients[msg.sender].patientAddress != address(0), "Patient not registered");
        patientToURIs[msg.sender].push(_dataURI);
        emit DataAdded(msg.sender, _dataURI);
    }

    function grantAccess(address doctor) public {
        require(patients[msg.sender].patientAddress != address(0), "Patient not registered");
        patientToAuthorizedDoctors[msg.sender].push(doctor);
        emit AccessGranted(msg.sender, doctor);
    } 

    function revokeAccess(address doctor) public {
        require(patients[msg.sender].patientAddress != address(0), "Patient not registered");
        address[] storage authorizedDoctors = patientToAuthorizedDoctors[msg.sender];

        for (uint i = 0; i < authorizedDoctors.length; i++){
            if (authorizedDoctors[i] == doctor){
                authorizedDoctors[i] = authorizedDoctors[authorizedDoctors.length-1];
                authorizedDoctors.pop();
                break;
            }
        }
        emit AccessRevoked(msg.sender, doctor);
    }

    function checkAccess(address patientAddress) public view returns (bool) {
        require(patients[patientAddress].patientAddress != address(0), "Patient not registered");
        address[] storage authorizedDoctors = patientToAuthorizedDoctors[patientAddress];

        for (uint i = 0; i < authorizedDoctors.length; i++){
            if (authorizedDoctors[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function getPatientData(address patientAddress) public view returns (string[] memory) {
        require(checkAccess(patientAddress), "Access denied");
        return patientToURIs[patientAddress];
    }

    function getMyData() public view returns (address, string[] memory) {
        require(patients[msg.sender].patientAddress != address(0), "Patient not registered");
        return (msg.sender, patientToURIs[msg.sender]);
    }

    function getAuthorizedDoctors() public view returns (address[] memory) {
        require(patients[msg.sender].patientAddress != address(0), "Patient not registered");
        return patientToAuthorizedDoctors[msg.sender];
    }
}
