// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalDataAccess {

    mapping(address => bool) private patients;
    mapping(address => bool) private doctors;
    mapping(address => mapping(address => bool)) private patientToAuthorizedDoctors;

    event AccessGranted(address indexed patient, address indexed doctor);
    event AccessRevoked(address indexed patient, address indexed doctor);

    function isPatient(address patient) public view returns (bool) {
        return patients[patient];
    }

    function isDoctor(address doctor) public view returns (bool) {
        return doctors[doctor];
    }

    function isDoctorAuthorized(address patient, address doctor) public view returns (bool) {
        require(isPatient(patient), "This is not a registered patient");
        require(isDoctor(doctor), "This is not a registered doctor");
        require(isPatient(msg.sender) || isDoctor(msg.sender), "Denied access");
        return patientToAuthorizedDoctors[patient][doctor];
    }

    function registerPatient() public {
        require(!isPatient(msg.sender), "Patient already registered");
        patients[msg.sender] = true;
    }

    function registerDoctor(address doctor) public {
        require(!isDoctor(doctor), "Doctor already registered");
        doctors[doctor] = true;
    }

    function authorizeDoctor(address doctor) public {
        require(isPatient(msg.sender), "Only patients can authorize doctors");
        require(isDoctor(doctor), "This is not a registered doctor");
        patientToAuthorizedDoctors[msg.sender][doctor] = true;
        emit AccessGranted(msg.sender, doctor);
    }

    function revokeDoctorAuthorization(address doctor) public {
        require(isPatient(msg.sender), "Only patients can revoke authorization");
        require(isDoctor(doctor), "This is not a registered doctor");
        require(isDoctorAuthorized(msg.sender, doctor), "Doctor didn´t have autorization");
        patientToAuthorizedDoctors[msg.sender][doctor] = false;
        emit AccessRevoked(msg.sender, doctor);
    }
}
