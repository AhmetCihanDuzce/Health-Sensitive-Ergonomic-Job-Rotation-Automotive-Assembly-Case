/*********************************************
 * OPL 22.1.1.0 Model
 * Author: Ahmet Cihan
 * Creation Date: 25 Haz 2026
 *********************************************/

int calisanSayisi = ...;
range Calisanlar = 1..calisanSayisi;

int istasyonSayisi = ...;
range Istasyonlar = 1..istasyonSayisi;

int planlamaUfku = ...;
range Haftalar = 1..planlamaUfku;

int Yeterlilik[Calisanlar][Istasyonlar] = ...;
float ToplamRebaSkoru[Istasyonlar] = ...;

int Yasaklanacaklar[Istasyonlar][1..7] = ...;
int ArdisikYasaklar[Istasyonlar][Istasyonlar];

execute{
  for (var j1 in Istasyonlar){
    for (var j2 in Istasyonlar){
      ArdisikYasaklar[j1][j2] = 0;
    }
  }
  
  for (var j1 in Istasyonlar){
  	for (var l = 1; l<=7; l++){
  	  if (Yasaklanacaklar[j1][l] == 0){
        for (var j2 in Istasyonlar){
          if(Yasaklanacaklar[j2][l] == 0){
            ArdisikYasaklar[j1][j2] = 1;
          }
        }
	  }
    }
  }
}

float M = max(j in Istasyonlar) ToplamRebaSkoru[j] - min(j in Istasyonlar) ToplamRebaSkoru[j] + 1;
float ToplamREBAM = planlamaUfku * max(j in Istasyonlar) ToplamRebaSkoru[j];

dvar float+ CalisanFark[Calisanlar];
dvar float+ calisanSapma;

dvar boolean x[Calisanlar][Istasyonlar][Haftalar];
dvar boolean y[Calisanlar][Istasyonlar];

dvar float+ Fark[Calisanlar][Haftalar];

// maximize sum (i in Calisanlar, j in Istasyonlar) (y[i][j]);
minimize calisanSapma;

subject to{
  // CalisanIstasyondaCalisiyormuKisiti ifadesi çalışanın ilgili istasyonda planlama döneminde çalışıp çalışmadığını
  // belirlemek için kullanılıyor.
  // y değişkeni çalışanın istasyonda en az bir planlama döneminde çalışmış olması durumunda 1 değeri alabiliyor. 
  // Çalışan, istasyonda hiç çalışmadı ise y değişkeni 0 değerini almak zorunda.
  // y değişkeninin 1 değerini alabilmesi için amaç işlevi göz önünde bulundurulmalı.

  forall (i in Calisanlar, j in Istasyonlar)
    CalisanIstasyondaCalisiyormuKisiti:
      sum(k in Haftalar) x[i][j][k] - y[i][j] >= 0;
  
  // İlk amacın sabitlenmesi kısıtı olarak kullanılıyor.
  // Eğer ilk amaç için çözülecek ise aşağıdaki kısıt kapatılmalıdır.
  // Elde edilen çözüm değeri ikinci amaç için çözüm yapılırken kısıta sağ taraf değeri olarak verilmelidir.
  
  AmacSabitleme: sum (i in Calisanlar, j in Istasyonlar) (y[i][j]) == 225;
  
  // ToplamREBASkoruDengesiKisiti ve ToplamSapmaKisiti ifadeleri her elemanın toplam REBA puanlarının 
  // dengeli dağılmasını sağlamak için kullanılıyor.
  // CalisanFark değişkeni her çalışanın alınabilecek en yüksek REBA puan toplamından ne kadar aşağıda puan aldığını tutuyor.
  // calisanSapma değişkeni ise CalisanFark değişkenlerinden en büyük olanını belirlemek için kullanılıyor. 
  // calisanSapma değişkeni en küçüklenir ise en yüksek yükü almış olan çalışanın REBA puanı en küçüklenmiş olur.
  
  forall (i in Calisanlar)
    ToplamREBASkoruDengesiKisiti:
  	  sum(j in Istasyonlar, k in Haftalar) (ToplamRebaSkoru[j] * x[i][j][k]) + CalisanFark[i] - ToplamREBAM == 0;
  
  forall (i in Calisanlar)
    ToplamSapmaKisiti:
      CalisanFark[i] - calisanSapma <= 0;
      
  // YeterlilikKisiti ifadesi çalışanların (Yeterlilik ile tanımlanmış olan) atanamayacağı yerlere atanmamalarını sağlar.
  YeterlilikKisiti:
    sum(i in Calisanlar, j in Istasyonlar, k in Haftalar) ((1 - Yeterlilik[i][j]) * x[i][j][k]) == 0;

  // IstasyonHafta1CalisanKisiti ifadesi her hafta her istasyona sadece ve sadece bir çalışanın atanmasını sağlar.
  forall (j in Istasyonlar, k in Haftalar)
    IstasyonHafta1CalisanKisiti:
      sum(i in Calisanlar) (x[i][j][k]) == 1;
  
  // CalisanHafta1IstasyonKisiti ifadesi her hafta her çalışanın sadece ve sadece bir istasyona atanmasını sağlar.
  forall (i in Calisanlar, k in Haftalar)
    CalisanHafta1IstasyonKisiti:
      sum(j in Istasyonlar) (x[i][j][k]) == 1;

  // ArdisikHaftalarRotasyonu ifadesi her çalışanın her iş geçişindeki REBA puan farklarının belirlenmesini sağlar. 
  forall (i in Calisanlar, j1 in Istasyonlar, j2 in Istasyonlar, k in Haftalar : k != planlamaUfku)
    ArdisikHaftalarRotasyonu:
      abs(ToplamRebaSkoru[j1] - ToplamRebaSkoru[j2]) - Fark[i][k] + M * (1 - x[i][j1][k]) + M * (1 - x[i][j2][k+1]) >= 0;

  // ArdisikHaftaYasaklari ifadesi ardışık haftalarda çalışılamayacak işlerin ardışık biçimde alınamamasını sağlar.
  forall (i in Calisanlar, j1 in Istasyonlar, j2 in Istasyonlar, k in Haftalar : k != planlamaUfku && ArdisikYasaklar[j1][j2] == 1)
    ArdisikHaftaYasaklari:
      x[i][j1][k] + x[i][j2][k+1] <= 1;
};
