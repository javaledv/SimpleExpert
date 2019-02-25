#property copyright "denLee"
#property link      "https://www.mql5.com"
#property version   "1.00"

input int stopLossValue = 30;
input int takeProfitValue = 100;
input double lotValue = 0.1;
 
input int adxPeriod = 8;
input double adxMin = 22.0;

input int maPeriod = 8;
input int eaMagic = 12345;

int adxHandle;
int maHandle;

double plsDi[],minDi[],adxVal[]; // динамические массивы для хранения численных значений +DI, -DI и ADX для каждого бара
double maVal[]; // динамический массив для хранения значений индикатора Moving Average для каждого бара
double priceClose; // переменная для хранения значения close бара

int stopLoss;
int takeProfit;

int OnInit() {
   
   adxHandle = iADX(_Symbol, _Period, adxPeriod);
   maHandle = iMA(_Symbol, _Period, maPeriod, MODE_EMA, PRICE_CLOSE);
   
   if (adxHandle < 0 || maHandle < 0) {
      Alert("Error during expert creation, error code: ", GetLastError(), "!!!");
      return(INIT_FAILED);
   }
   
   stopLoss = stopLossValue;
   takeProfit = takeProfitValue;
   
   if (_Digits == 5 || _Digits == 3) {
      stopLoss = stopLoss * 10;
      takeProfit = takeProfit * 10;
   }
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   IndicatorRelease(adxHandle);
   IndicatorRelease(maHandle);
}

void OnTick() {

   if (Bars(_Symbol, _Period) < 60) {
      Alert("Bars emount is less then 60... ");
      return;
   }
   
   static datetime oldTime;
   datetime newTime[1];
   
   bool isNewBar = false;
   
   int copied = CopyTime(_Symbol, _Period, 0, 1, newTime);
   if (copied < 0) {
      Alert("Error time coping... Error code: ", GetLastError());
      ResetLastError();
      return;
   }
   
   if (oldTime != newTime[0]) {
      isNewBar = true;
      if(MQL5InfoInteger(MQL5_DEBUGGING)) Print("New bar", newTime[0], "Old bar", oldTime);
      oldTime = newTime[0];
   }
   
   if (!isNewBar) {
      return;
   }
   
   if (Bars(_Symbol, _Period) < 60) {
      Alert("Bars emount is less then 60... ");
      return;
   }
   
   MqlTick latestPrice;
   MqlTradeRequest mRequest;
   MqlTradeResult mResult;
   MqlRates mRates[];
   ZeroMemory(mRequest);
}