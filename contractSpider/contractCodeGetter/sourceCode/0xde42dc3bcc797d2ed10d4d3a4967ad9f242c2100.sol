/**
 *Submitted for verification at Etherscan.io on 2020-07-21
*/

// File: contracts/ITabularium.sol

// SPDX-License-Identifier: UNLICENSED"

pragma solidity >=0.4.21 <0.7.0;

interface ITabularium {

  function defineSmcAddress(address _smc) external;

  function addMeasurement(
    uint256 id,
    int256 status,
    int256 receivable,
    int256 creditDebit,
    int256 specificValueRatio,
    int256 producedSteel
  ) external;

  function defineAverageSpecificValueRatio() 
    external view returns (int256);

  function defineBaseAdjustment(
    int256 averageSpecificValueRatio,
    int256 contractedValueRatio,
    int256 stopLimit
  ) external view returns (int256 _baseAdjustment);

  function calculationPipeline(
    int256 totalInvoicedMaterial,
    int256 producedSteel,
    int256 coefficient,
    int256 contractedValueRatio
  ) external returns (
      int256 _specificPayment,
      int256 _creditDebit,
      int256 _specificValueRatio,
      int256 _status
  );

}

// File: contracts/SMCRHIMagnesita.sol

pragma solidity >=0.4.21 <0.7.0;



contract SMCRHIMagnesita {
    enum MeasurementStatus {
        EMPTY,
        WAITING_HIRED_TECHNICIAN,
        WAITING_CONTRACTOR_TECHNICIAN,
        WAITING_HIRED_COMMERCIAL,
        WAITING_CONTRACTOR_COMMERCIAL,
        WAITING_ARBITER,
        TECHNICALLY_APPROVED,
        TECHNICALLY_DISAPPROVED,
        COMMERCIALLY_DISAPPROVED,
        COMMERCIALLY_APPROVED
    }

    enum Action {
        EMPTY,
        OPEN,
        MEASURE,
        DISSAPROVAL,
        APPROVAL,
        ARBITER_CALL,
        ARBITER_MEASURE,
        CLOSE
    }

    enum MeasurementType {EMPTY, TECHNICAL, COMMERCIAL}

    enum Variables {
        IS_OPEN,
        START_DATE,
        END_DATE,
        LABEL,
        // ADMIN
        STOP_LIMIT,
        CONTRACTED_VALUE_RATIO,
        COEFFICIENT,
        // FINANCIAL
        CREDIT_DEBIT,
        RECEIVABLE,
        SPECIFIC_VALUE_RATIO,
        STATUS,
        // TECHNICAL
        RUN_NUMBER,
        TIMESTAMP,
        VACUUM_TIME,
        BLOWN_OXIGEN_ON_RUN,
        TECHNICAL_NOTES,
        TECHNICAL_JUSTIFICATIVE,
        TECHNICAL_FILES,
        // COMMERCIAL
        PRODUCED_STEEL,
        TOTAL_INVOICED_MATERIAL,
        COMMERCIAL_NOTES,
        COMMERCIAL_JUSTIFICATIVE,
        COMMERCIAL_FILES
    }

    int256 public ONE = 100000000000000;
    bytes32 public TRUE = bytes32("TRUE");
    bytes32 public FALSE = bytes32("FALSE");
    
    int256 public stopLimit = 1228800000000000;
    int256 public contractedValueRatio = 1019900000000000;
    int256 public coefficient = 70000000000000;

    mapping(uint256 => mapping(uint256 => int256)) public financialVariables;
    mapping(uint256 => mapping(uint256 => bytes32)) public measurementVariables;
    mapping(uint256 => MeasurementStatus) public measurementStatus;
    mapping(uint256 => string) public measurementLabels;

    mapping(uint256 => mapping(uint256 => bytes32)) public eventVariables;

    mapping(uint256 => Action) public eventAction;
    mapping(uint256 => MeasurementType) public eventMeasurementType;
    mapping(uint256 => address) public eventUser;

    address public owner;
    address public arbiter;
    address public contractorTechnician;
    address public hiredTechnician;
    address public contractorCommercial;
    address public hiredCommercial;

    ITabularium tab;

    constructor() public {
        owner = msg.sender;
    }

    function setTabulariumAddress(address _tabulariumAddress) public isOwner {
        tab = ITabularium(_tabulariumAddress);
    }

    function getMeasurementId(string memory _label) public pure returns (uint256){
        return uint256(keccak256(abi.encodePacked(_label)));
    }

    modifier isOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    modifier measurementIsOpen(string memory _label) {
        uint256 measurementId = getMeasurementId(_label);

        require(measurementVariables[measurementId][uint256(Variables.IS_OPEN)] == TRUE, "no open measurement");
        _;
    }
    modifier canBeTechnicallyMeasured(string memory _label, bytes32 _startDate, bytes32 _endDate) {
        uint256 measurementId = getMeasurementId(_label);

        if (measurementStatus[measurementId] == MeasurementStatus.WAITING_ARBITER) {
            require(msg.sender == arbiter, "Arbiter must be called");
        } else if (measurementVariables[measurementId][uint256(Variables.IS_OPEN)] != TRUE &&
                     measurementStatus[measurementId] != MeasurementStatus.COMMERCIALLY_APPROVED) {
            require(msg.sender == hiredTechnician || msg.sender == contractorTechnician, "Only technician can open a Measurement");
         } else if (measurementStatus[measurementId] == MeasurementStatus.TECHNICALLY_DISAPPROVED) {
            require(measurementVariables[measurementId][uint256(Variables.START_DATE)] == _startDate && 
                      measurementVariables[measurementId][uint256(Variables.END_DATE)] == _endDate,
                    "Measurement must have same start and end date!");
            require(msg.sender == hiredTechnician || msg.sender == contractorTechnician, "Must be Technician");
         }
         else {
            require(false, "Wrong role or Wrong time");
        }
        _;
    }
    modifier canBeTechnicallyApproved(string memory _label, bool _decision) {
        uint256 measurementId = getMeasurementId(_label);

        if (measurementStatus[measurementId] == MeasurementStatus.WAITING_CONTRACTOR_TECHNICIAN) {
            require(msg.sender == contractorTechnician, "Only the contractor technician");
        } else if (measurementStatus[measurementId] == MeasurementStatus.WAITING_HIRED_TECHNICIAN) {
            require(msg.sender == hiredTechnician, "Only the hired technician");
        } else if (measurementStatus[measurementId] == MeasurementStatus.WAITING_ARBITER) {
            require(msg.sender == arbiter, "Only arbiter");
            require(_decision == true, "Arbiter can't Reprove a Measurement");
        } else {
            require(false, "Measurement not waiting for this action or user has wrong role");
        }
        _;
    }
    modifier canBeCommerciallyMeasured(string memory _label) {
        uint256 measurementId = getMeasurementId(_label);

        if (measurementStatus[measurementId] == MeasurementStatus.WAITING_ARBITER) {
            require(msg.sender == arbiter, "Arbiter not called");
        } else if (measurementStatus[measurementId] == MeasurementStatus.COMMERCIALLY_DISAPPROVED || 
                   measurementStatus[measurementId] == MeasurementStatus.TECHNICALLY_APPROVED ) {
             require(msg.sender == hiredCommercial || 
                     msg.sender == contractorCommercial, "Only commercial participants");
        } else { 
            require(false, "Measurement not waiting for this action or user has wrong role");
        }
        _;
    }
    modifier canBeCommerciallyApproved(string memory _label, bool _decision) {
        uint256 measurementId = getMeasurementId(_label);

        if (measurementStatus[measurementId] == MeasurementStatus.WAITING_CONTRACTOR_COMMERCIAL) {
            require(msg.sender == contractorCommercial, "Only contractor commercial and arbiter");
        } else if (measurementStatus[measurementId] == MeasurementStatus.WAITING_HIRED_COMMERCIAL) {
            require(msg.sender == hiredCommercial, "Only hired commercial and arbiter " );
        } else if (measurementStatus[measurementId] == MeasurementStatus.WAITING_ARBITER) {
            require(msg.sender == arbiter, "Only arbiter ");
            require(_decision == true, "Arbiter can't Reprove a Measurement");
        } else {
            require(false,  "Measurement not waiting for this action or user has wrong role");
        }
        _;
    }
    modifier userCanCallArbiter(string memory _label) {
        uint256 measurementId = getMeasurementId(_label);

        if (measurementStatus[measurementId] == MeasurementStatus.TECHNICALLY_DISAPPROVED) {
            require(msg.sender == hiredTechnician || msg.sender == contractorTechnician, "Only technician");
        } else if (measurementStatus[measurementId] == MeasurementStatus.COMMERCIALLY_DISAPPROVED) {
            require(msg.sender == hiredCommercial || msg.sender == contractorCommercial, "Only commercial");
        } else {
            require(false, "Measurement not waiting for this action or user has wrong role");
        }
        _;
    }

    function defineArbiter(address _arbiter) public isOwner {
        arbiter = _arbiter;
    }

    function defineContractorTechnician(address _contractorTechnician) public isOwner {
        contractorTechnician = _contractorTechnician;
    }

    function defineHiredTechnician(address _hiredTechnician) public isOwner {
        hiredTechnician = _hiredTechnician;
    }

    function defineContractorCommercial(address _contractorCommercial) public isOwner {
        contractorCommercial = _contractorCommercial;
    }

    function defineHiredCommercial(address _hiredCommercial) public isOwner {
        hiredCommercial = _hiredCommercial;
    }

    function registerTechnicalMeasurement(
        string memory _label,
        bytes32 _startDate,
        bytes32 _endDate,
        bytes32 _runNumber,
        bytes32 _timeStamp,
        bytes32 _vacuumTime,
        bytes32 _blownOxigenOnRun,
        bytes32 _technicalNotes,
        bytes32 _technicalFiles
    ) public canBeTechnicallyMeasured(_label, _startDate, _endDate) {
        uint256 measurementId = getMeasurementId(_label);
        
        eventUser[measurementId] = msg.sender;
        eventMeasurementType[measurementId] = MeasurementType.TECHNICAL;

        if (msg.sender == arbiter) {
            eventAction[measurementId] = Action.ARBITER_MEASURE;
            measurementStatus[measurementId] = MeasurementStatus.TECHNICALLY_APPROVED;
        } else {
            if (measurementVariables[measurementId][uint256(Variables.IS_OPEN)] != TRUE) {
                eventAction[measurementId] = Action.OPEN;
                measurementLabels[measurementId] = _label;
                measurementVariables[measurementId][uint256(Variables.IS_OPEN)] = TRUE;
                measurementVariables[measurementId][uint256(Variables.START_DATE)] = _startDate;
                measurementVariables[measurementId][uint256(Variables.END_DATE)] = _endDate;
            } else {
                eventAction[measurementId] = Action.MEASURE;
            }
            if (msg.sender == contractorTechnician) {
                measurementStatus[measurementId] = MeasurementStatus.WAITING_HIRED_TECHNICIAN;
            } else {
                measurementStatus[measurementId] = MeasurementStatus.WAITING_CONTRACTOR_TECHNICIAN;
            }
        }
        
        eventVariables[measurementId][uint256(Variables.RUN_NUMBER)] = _runNumber;
        eventVariables[measurementId][uint256(Variables.TIMESTAMP)] = _timeStamp;
        eventVariables[measurementId][uint256(Variables.VACUUM_TIME)] = _vacuumTime;
        eventVariables[measurementId][uint256(Variables.BLOWN_OXIGEN_ON_RUN)] = _blownOxigenOnRun;
        eventVariables[measurementId][uint256(Variables.TECHNICAL_NOTES)] = _technicalNotes;
        eventVariables[measurementId][uint256(Variables.TECHNICAL_FILES)] = _technicalFiles;
    }

    function approveTechnicalMeasurement(
        string memory _label,
        bool _decision,
        bytes32 _technicalJustificative
    ) public measurementIsOpen(_label) canBeTechnicallyApproved(_label, _decision) {
        uint256 measurementId = getMeasurementId(_label);

        eventMeasurementType[measurementId] = MeasurementType.TECHNICAL;
        eventUser[measurementId] = msg.sender;
       
        if (_decision == true) {
            eventAction[measurementId] = Action.APPROVAL;
            measurementStatus[measurementId] = MeasurementStatus.TECHNICALLY_APPROVED;
        } else if (_decision == false) {
            eventAction[measurementId] = Action.DISSAPROVAL;
            measurementStatus[measurementId] = MeasurementStatus.TECHNICALLY_DISAPPROVED;
        }
        else {
            revert("Decision not boolean"); // não sei se precisa
        }
        
        eventVariables[measurementId][uint256(Variables.TECHNICAL_JUSTIFICATIVE)] = _technicalJustificative;
    }

    function registerCommercialMeasurement(
        string memory _label,
        int256 _producedSteel,
        int256 _totalInvoicedMaterial,
        bytes32 _commercialNotes,
        bytes32 _commercialFiles,
        bool _updateAdminVariables,
        int256 _stopLimit,
        int256 _contractedValueRatio,
        int256 _coefficient
    )
        public
        canBeCommerciallyMeasured(_label)
    {
        uint256 measurementId = getMeasurementId(_label);
        eventUser[measurementId] = msg.sender;
        eventMeasurementType[measurementId] = MeasurementType.COMMERCIAL;

        if (msg.sender == arbiter) {
            eventAction[measurementId] = Action.ARBITER_MEASURE;

            measurementVariables[measurementId][uint256(Variables.IS_OPEN)] = FALSE;
            measurementStatus[measurementId] = MeasurementStatus.COMMERCIALLY_APPROVED;
            setFinancialMeasurement(measurementId);
        } else {
            eventAction[measurementId] = Action.MEASURE;

            if (msg.sender == contractorCommercial) {
                measurementStatus[measurementId] = MeasurementStatus.WAITING_HIRED_COMMERCIAL;
            } else {
                measurementStatus[measurementId] = MeasurementStatus.WAITING_CONTRACTOR_COMMERCIAL;
            }
        }

        financialVariables[measurementId][uint256(Variables.PRODUCED_STEEL)] = _producedSteel;
        financialVariables[measurementId][uint256(Variables.TOTAL_INVOICED_MATERIAL)] = _totalInvoicedMaterial;

        if (_updateAdminVariables == true) {
            financialVariables[measurementId][uint256(Variables.STOP_LIMIT)] = _stopLimit;
            financialVariables[measurementId][uint256(Variables.CONTRACTED_VALUE_RATIO)] = _contractedValueRatio;
            financialVariables[measurementId][uint256(Variables.COEFFICIENT)] = _coefficient;

            stopLimit = _stopLimit;
            contractedValueRatio = _contractedValueRatio;
            coefficient = _coefficient;
        }

        
        eventVariables[measurementId][uint256(Variables.COMMERCIAL_NOTES)] = _commercialNotes;
        eventVariables[measurementId][uint256(Variables.COMMERCIAL_FILES)] = _commercialFiles;
    }

    function approveCommercialMeasurement(
        string memory _label,
        bool _decision,
        bytes32 _commercialJustificative
    ) public measurementIsOpen(_label) canBeCommerciallyApproved(_label, _decision) {
        uint256 measurementId = getMeasurementId(_label);
        
        eventMeasurementType[measurementId] = MeasurementType.COMMERCIAL;
        eventUser[measurementId] = msg.sender;
        if (_decision == true) {
            eventAction[measurementId] = Action.APPROVAL;
            measurementStatus[measurementId] = MeasurementStatus.COMMERCIALLY_APPROVED;
            measurementVariables[measurementId][uint256(Variables.IS_OPEN)] = FALSE;
            setFinancialMeasurement(measurementId);
        } else {
            eventAction[measurementId] = Action.DISSAPROVAL;
            measurementStatus[measurementId] = MeasurementStatus.COMMERCIALLY_DISAPPROVED;
        }

        
        eventVariables[measurementId][uint256(Variables.COMMERCIAL_JUSTIFICATIVE)] = _commercialJustificative;
    }

    function callArbiter(string memory _label) public userCanCallArbiter(_label) measurementIsOpen(_label) {
        uint256 measurementId = getMeasurementId(_label);

        if (msg.sender == hiredTechnician || msg.sender == contractorTechnician) {
            eventMeasurementType[measurementId] = MeasurementType.TECHNICAL;
        } else if (msg.sender == hiredCommercial || msg.sender == contractorCommercial) {
            eventMeasurementType[measurementId] = MeasurementType.COMMERCIAL;
        }

        eventAction[measurementId] = Action.ARBITER_CALL;
        measurementStatus[measurementId] = MeasurementStatus.WAITING_ARBITER;
    }

    function addFinancialMeasurement(
        uint256 _id,
        int256 _status,
        int256 _receivable,
        int256 _creditDebit,
        int256 _specificValueRatio,
        int256 _producedSteel
    ) public isOwner {
        tab.addMeasurement(
            _id,
            _status,
            _receivable,
            _creditDebit,
            _specificValueRatio,
            _producedSteel
        );
    }

    function defineBaseAdjustment() public isOwner {
        int256 averageSpecificValueRatio = tab
            .defineAverageSpecificValueRatio();

        contractedValueRatio = tab.defineBaseAdjustment(
            averageSpecificValueRatio,
            contractedValueRatio,
            stopLimit
        );
    }

    function setFinancialMeasurement(uint256 _measurementId) private {
        (
            int256 specificPayment,
            int256 creditDebit,
            int256 specificValueRatio,
            int256 status
        ) = tab.calculationPipeline(
            financialVariables[_measurementId][uint256(Variables.TOTAL_INVOICED_MATERIAL)],
            financialVariables[_measurementId][uint256(Variables.PRODUCED_STEEL)],
            coefficient,
            contractedValueRatio
        );

        financialVariables[_measurementId][uint256(Variables.RECEIVABLE)] = specificPayment;
        financialVariables[_measurementId][uint256(Variables.CREDIT_DEBIT)] = creditDebit;
        financialVariables[_measurementId][uint256(Variables.SPECIFIC_VALUE_RATIO)] = specificValueRatio;
        financialVariables[_measurementId][uint256(Variables.STATUS)] = status;

        tab.addMeasurement(
            _measurementId,
            financialVariables[_measurementId][uint256(Variables.STATUS)],
            financialVariables[_measurementId][uint256(Variables.RECEIVABLE)],
            financialVariables[_measurementId][uint256(Variables.CREDIT_DEBIT)],
            financialVariables[_measurementId][uint256(Variables.SPECIFIC_VALUE_RATIO)],
            financialVariables[_measurementId][uint256(Variables.PRODUCED_STEEL)]
        );
    }
}