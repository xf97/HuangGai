/**
 *Submitted for verification at Etherscan.io on 2020-06-26
*/

pragma solidity 0.5.12;

contract Laurea {
    
    address laurea; 

    struct School {
        string name;
        string taxID;
        address schoolAddress;
    }
    
    struct CertificadoAluno {
        string codigoAluno;
        string codigoCurso;
        string nomeAluno;
        string nomeCurso;
        string dataInicioFim;
        uint8 cargaHoraria;
        bytes32 hashCertificado;
        bool exists;
    }
    
    School public school;
    mapping(bytes32 => CertificadoAluno) public certificados;
    
    event StudentLaurated(string indexed codigoCurso, string indexed codigoAluno, bytes32 hashCertificado);
    
    constructor(string memory _name, string memory _taxID, address _schoolAddress) public {
        laurea = msg.sender;
        school = School(_name, _taxID, _schoolAddress);
    }
    
    function editSchool(string memory _name, string memory _taxID, address _schoolAddress) public {
        require (msg.sender == school.schoolAddress || msg.sender == laurea);
        school = School(_name, _taxID, _schoolAddress);
    }
    
    function addCertificado(string memory _codigoAluno, string memory _codigoCurso, string memory _nomeAluno, string memory _nomeCurso, string memory  _dataInicioFim,  uint8 _cargaHoraria) public returns (bytes32) {
        require (msg.sender == school.schoolAddress || msg.sender == laurea);
        bytes32 hashCertificado = keccak256(abi.encodePacked(school.name,_codigoAluno, _codigoCurso));
        CertificadoAluno memory ca = CertificadoAluno(_codigoAluno, _codigoCurso, _nomeAluno, _nomeCurso, _dataInicioFim, _cargaHoraria, hashCertificado, true);
        certificados[hashCertificado] = ca;
        emit StudentLaurated (ca.codigoCurso, ca.codigoAluno, hashCertificado);
        return hashCertificado;
    }
    
    function alterarCertificado (bytes32 _hash, string memory _nomeAluno, string memory _nomeCurso, string memory  _dataInicioFim,  uint8 _cargaHoraria ) public returns(bool) {
        require (msg.sender == school.schoolAddress || msg.sender == laurea);
        CertificadoAluno storage ca = certificados[_hash];
        ca.nomeAluno = _nomeAluno;
        ca.nomeCurso = _nomeCurso;
        ca.dataInicioFim = _dataInicioFim;
        ca.cargaHoraria = _cargaHoraria;
        emit StudentLaurated (ca.codigoCurso, ca.codigoAluno, _hash);
        return true;
    }
    
    function alterarEstadoCertificado (bytes32 _hash) public returns(bool) {
        require (msg.sender == school.schoolAddress || msg.sender == laurea);
        CertificadoAluno storage ca = certificados[_hash];
        if (ca.exists == true) {
            ca.exists = false;
            return true;
        } 
        else { 
            ca.exists = true;
            return true;
        }
    }
    
    function buscarCertificado(string memory _codigoAluno, string memory _codigoCurso) public view returns (string memory, string memory, string memory, string memory, string memory, uint, bytes32) {
        CertificadoAluno memory ca = certificados[keccak256(abi.encodePacked(school.name, _codigoAluno, _codigoCurso))];
        require(ca.exists == true, "Certificado não localizado");
        return (ca.codigoAluno, ca.codigoCurso, ca.nomeAluno, ca.nomeCurso, ca.dataInicioFim, ca.cargaHoraria, ca.hashCertificado);
    }
    
    function buscarCertificadoHash(bytes32 _hash) public view returns (string memory, string memory, string memory, string memory, string memory, uint, bytes32) {
        CertificadoAluno memory ca = certificados[_hash];
        require(ca.exists == true, "Certificado não localizado");
        return (ca.codigoAluno, ca.codigoCurso, ca.nomeAluno, ca.nomeCurso, ca.dataInicioFim, ca.cargaHoraria, ca.hashCertificado);
    }
}