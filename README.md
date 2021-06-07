# VHDLileBasitIslemciTasarimi
Bu kod Karadeniz Teknik Üniversitesi Bilgisayar Mühendisliği bölümü Donanım Tanımlama Dilleri dersinde verilen proje için yazılmıştır.
# AYRINTILI TASARIM ACIKLAMASI
•	Library anahtar kelimesiyle gerekli kütüphaneleri; use anahtar kelimesiyle gerekli paketleri import ediyoruz. 
  library ieee;
  use ieee.std_logic_1164.all; -- Paketi gelişmiş sinyal türlerini import etmemizi sağlar.
  use IEEE.Numeric_Std.all; -- Sayısal hesaplamaları sağlar.

•	Architecture kısmında işlemcide bulunan RAM ve REGİSTER tanımlarını yapıyoruz.
  TYPE tMEM IS ARRAY(0 TO 63) OF std_logic_vector(n-1 DOWNTO 0); -- Her biri 8bitlik 64 hucreden olusan RAM
  SIGNAL Ram : tMEM;  -- tMEM dizisinde tanimli sinyal Ram
  TYPE tREG IS ARRAY(0 TO 15) OF std_logic_vector(n-1 DOWNTO 0); -- Her biri 8 bitlik 16 tane registerdan olusan register kumemiz
  SIGNAL Reg : tREG; -- tReg dizisinde tanimli sinyal Register

•	ALU yani Arithmetic Logic Unit devrede işlemciye aritmetik ve mantıksal işlemleri gerçekleyecek olan birim.

•	Begin bölümünde işlemcimizin mimarisini tasarlıyoruz.
If( Rising_edge(s) ) then -- Saatin yukselen kenari geldikten sonra
Case Kmt(15 downto 12) is -- Komut girisinin en anlamli 4 bitine gore asagidaki islemleri yap
“0000” -> null – işlem yapma 
“0001” -> Sabit bir değeri registera yükleme işlemini yap
“0010” -> Registerdan registera yükleme işlemini yap
“0011” -> Bellekten registera yükleme işlemin yap
“0100” -> Registerdaki bilgiyi adres olarak alıp bellekten registera yükleme yap
“0101” -> Registerdaki bilgiyi RAM de saklama yap
“0110” -> Sabit bir sayı ile registerı toplama işlemi yap
“0111” -> Registerlarda toplama yap
“1000” -> Registerlarda çıkarma işlemi
“1001” -> Registerlarda bölme işlemi
“1010” -> Registerlarda mod alma işlemi
“1011” -> Registerları and leyip başka bir registera yazma
“1100” -> Registerları nand leyip başka bir registera yazma
“1101” -> Registerları or layıp başka bir registera yazma
“1110” -> Registerları nor layıp başka bir registera yazma 
“1111” -> Registerları xor layıp başka bir registera yazma

