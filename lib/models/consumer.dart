
class MonthlyBill {
  final String billBasis;
  final String consumerStatus;
  final String billMonth;
  final String spotBillingMachineNumber;
  final String billIssueDate;
  final String billDueDate;
  final int presentReading;
  final int previousReading;
  final String currentReadingDate;
  final int unitsConsumed;
  final int fixedCharges;
  final int energyCharges;
  final int totalCurrentBill;
  final int arrearBalance;
  final int amountBilled;
  final int creditAmount;
  final int debitAmount;
  final int fixedChargesRealized;
  final int energyChargesRealized;
  final int totalRealized;
  final int arrearTotalRealized;
  final int currentBalance;
  final int currentExcesspaid;

  MonthlyBill({
    required this.billBasis,
    required this.consumerStatus,
    required this.billMonth,
    required this.spotBillingMachineNumber,
    required this.billIssueDate,
    required this.billDueDate,
    required this.presentReading,
    required this.previousReading,
    required this.currentReadingDate,
    required this.unitsConsumed,
    required this.fixedCharges,
    required this.energyCharges,
    required this.totalCurrentBill,
    required this.arrearBalance,
    required this.amountBilled,
    required this.creditAmount,
    required this.debitAmount,
    required this.fixedChargesRealized,
    required this.energyChargesRealized,
    required this.totalRealized,
    required this.arrearTotalRealized,
    required this.currentBalance,
    required this.currentExcesspaid,
  });
}

class Consumer {
  final String tariffCategory;
  final String consumerCode;
  final String clusterCode;
  final String consumerName;
  final String consumerAddress;
  final String consumerCity;
  final String meterNumber;
  final String dateOfConnection;
  final String contractDemand;
  final List<MonthlyBill> monthlyBill;

  Consumer({
    required this.tariffCategory,
    required this.consumerCode,
    required this.clusterCode,
    required this.consumerName,
    required this.consumerAddress,
    required this.consumerCity,
    required this.meterNumber,
    required this.dateOfConnection,
    required this.contractDemand,
    required this.monthlyBill,
  });
}
