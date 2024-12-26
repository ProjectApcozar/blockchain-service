// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalDataAccess {

    mapping(address => bool) private patients;
    mapping(address => bool) private doctors;

    event AccessGranted(address indexed patient, address indexed doctor);
    event AccessRevoked(address indexed patient, address indexed doctor);

    error PatientAlreadyRegistered();
    error DoctorAlreadyRegistered();
    error NotAPatient();
    error NotADoctor();

    function removePatient(address patient) public {
        if(!isPatient(patient)) revert NotAPatient();
        patients[patient] = false;
    }

    function removeDoctor(address doctor) public {
        if(!isDoctor(doctor)) revert NotADoctor();
        doctors[doctor] = false;
    }

    function isPatient(address patient) public view returns (bool) {
        return patients[patient];
    }

    function isDoctor(address doctor) public view returns (bool) {
        return doctors[doctor];
    }

    function registerPatient() public {
        if (isPatient(msg.sender)) revert PatientAlreadyRegistered();
        patients[msg.sender] = true;
    }

    function registerDoctor(address doctor) public {
        if(isDoctor(doctor)) revert DoctorAlreadyRegistered();
        doctors[doctor] = true;
    }

    function authorizeDoctor(address doctor) public {
        if(!isPatient(msg.sender)) revert NotAPatient();
        if(!isDoctor(doctor)) revert NotADoctor();
        emit AccessGranted(msg.sender, doctor);
    }

    function revokeDoctorAuthorization(address doctor) public {
        if(!isPatient(msg.sender)) revert NotAPatient();
        if(!isDoctor(doctor)) revert NotADoctor();
        emit AccessRevoked(msg.sender, doctor);
    }
}
