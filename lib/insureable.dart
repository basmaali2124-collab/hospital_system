
mixin Insurable {
  String? _insuranceCompany;
  int  _coveragePercent=0;
   
  String get insuranceCompany =>_insuranceCompany?? "No insurance";
  int get coveragePercent =>_coveragePercent;

  set insuranceCompany(String insuranceCompany)=>_insuranceCompany=insuranceCompany;
  set coveragePercent(int percent){
   if(percent<0){
      throw Exception("Insurance coverage cannot be negative");
    } 
   else if(percent>80){
      throw Exception("Insurance coverage cannot exceed 80%");
    }
    _coveragePercent=percent;
  }
  double applyInsurance(double amount){
 double total = amount-((amount*coveragePercent)/100);
return total;
}
}