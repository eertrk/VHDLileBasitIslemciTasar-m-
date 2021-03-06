-- Emirhan Ert?rk 330129
-- DONANIM TANIMLAMA DILLERI VHDL PROJESI
-- BASIT ISLEMCI TASARIMI
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

entity eIslemci is
generic(n:natural:=8);
port( s : in std_logic; 
     kmt: in std_logic_vector(2*n-1 downto 0) -- 16 bit giris secme
);
end entity;

Architecture struct of eIslemci is

TYPE tMEM IS ARRAY(0 TO 63) OF std_logic_vector(n-1 DOWNTO 0); -- Her biri 8bitlik 64 hucreden olusan RAM
SIGNAL Ram : tMEM;  -- tMEM dizisinde tanimli sinyal Ram

TYPE tREG IS ARRAY(0 TO 15) OF std_logic_vector(n-1 DOWNTO 0); -- Her biri 8 bitlik 16 tane registerdan olusan register kumemiz
SIGNAL Reg : tREG; -- tReg dizisinde tanimli sinyal Reg

Begin -- mimari

Komut:
process(s)
Begin
     If( Rising_edge(s) ) then -- Saatin yukselen kenari geldikten sonra
     Case Kmt(15 downto 12) is -- Komut girisinin en anlamli 4 bitine gore asagidaki islemleri yap

	When "0000" => -- Eger 0000 ise
	    null;   -- islem yapma... 



	-- LOADx	SABIT BIR DEGERI REGISTERA YUKLEME ISLEMI   0001  4bitREGadresi   8bit sabit sayi
	When "0001" => 
		--	         register adresi               sabit deger
		Reg(to_integer(unsigned(Kmt(11 downto 8)))) <= Kmt(7 downto 0);  




	-- LOADr	REGISTERDAN REGISTERA YUKLEME ISLEMI   0010  4bitREGadresi   4bitREGadresiKaynak         Loadr  ax, bx    -- ax<=bx
	When "0010" =>  
		Reg(  to_integer(unsigned(Kmt(11 downto 8))))  <= Reg(  to_integer(unsigned(Kmt(7 downto 4)) ))  ;




	-- LOADm	BELLEKTEN REGISTERA YUKLEME ISLEMI     0011  REGadresi   8bitRamAdresi
	When "0011" =>  
		Reg(  to_integer(unsigned(Kmt(11 downto 8))))  <= Ram(  to_integer(unsigned(Kmt(7 downto 0)) ))  ; -- Ram adresindeki bilgiyi Rwegistera getirir.
	



	-- LOADmr	REGISTERDAKI BILGIYI ADRES OLARAK KABUL EDIP BELLEKTEN REGISTERA YUKLEME ISLEMI    0100  REGadresi   RegAdresi 
	When "0100" => 
		--              1.register adresi                         bellek adresi                     2.register adresi
		Reg(  to_integer(unsigned(Kmt(11 downto 8))))  <= Ram( to_integer(unsigned( Reg( to_integer(unsigned(Kmt(7 downto 4)))  ))))  ;




	-- STOREr	REGISTERDAKI BILGIYI RAME SAKLAMA ISLEMI   0101  REGadresi   8bitRamAdresi 
	When "0101" => 
		--           bellek adresi                                      register adresi
		Ram( to_integer(unsigned(Kmt(7 downto 0))) ) <= Reg( to_integer(unsigned(Kmt(11 downto 8)))); 




	-- ADDx		SABIT BIR SAYI ILE REGISTERI TOPLAMA ISLEMI    0110  4bitRegAdresi     8bit sabit Sayi 	
 	When "0110" =>  
		--             register adresi                                                 register adresinin sayisal degeri             sabit degerin sayisal degeri
		Reg(  to_integer(unsigned(Kmt(11 downto 8))) )   <= std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(11 downto 8))))) + unsigned(Kmt (7 downto 0))); -- add  ax,  x     x sabit sayi ile ax toplanir sonuc ax'e yazilir

	



	-- ADDr		REGISTERLARI TOPLAMA ISLEMI   0111  4bitRegAdresi     4bitRegAdresi  
 	When "0111" =>  
		--             1.register (ax) adresi                                      2.register adresinin (bx) sayisal degeri               3.register adresinin (cx) sayisal degeri 
		Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4))))) + unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  );  -- addr     ax,  bx , cx      cx  bx toplanir sonuc ax'e yazilir
	

		
	-- Diger islemler buraya eklenecek...
	-- aritmetik ve mantiksal islemler...

	-- SUBr		REGISTERLARI CIKARMA ISLEMI   1000  4bitRegAdresi     4bitRegAdresi  
 	When "1000" =>  
		--             1.register (ax) adresi                                      2.register adresinin (bx) sayisal degeri               3.register adresinin (cx) sayisal degeri 
		Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4))))) - unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  ); -- SUBr     ax,  bx , cx      cx  bx cikarilir sonuc ax'e yazilir


	-- DIVr		REGISTERLARI B?lme ISLEMI   1001  4bitRegAdresi     4bitRegAdresi  
 	When "1001" =>  
		--             1.register (ax) adresi                                      2.register adresinin (bx) sayisal degeri               3.register adresinin (cx) sayisal degeri 
		Ram( to_integer(unsigned(Kmt(11 downto 8)) ))   <= std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4))))) / unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  ); -- SUBr     ax,  bx , cx      cx  bx bolunur sonuc ax'e yazilir



	-- MODr		REGISTERLARI MOD ALMA ISLEMI   1010  4bitRegAdresi     4bitRegAdresi  
 	When "1010" =>  
		--             1.register (ax) adresi                                      2.register adresinin (bx) sayisal degeri               3.register adresinin (cx) sayisal degeri 
		Ram( to_integer(unsigned(Kmt(11 downto 8)) ))   <= std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4))))) mod unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  ); -- SUBr     ax,  bx , cx      cx  bx bolunur kalan ax'e yazil






	-- ANDGATEr	REGISTERLARI AND'LEYIP RAME YAZMA ISLEMI
	When "1011" =>
		Ram( to_integer(unsigned(Kmt(11 downto 8))) ) <=  Reg( to_integer(unsigned(Kmt(7 downto 4)) )) and Reg( to_integer(unsigned(Kmt(3 downto 0)) )) ;




	-- NANDGATEr	REGISTERLARI NAND'LAYIP RAME YAZMA ISLEMI
	When "1100" =>
		Ram( to_integer(unsigned(Kmt(11 downto 8))) ) <=  Reg( to_integer(unsigned(Kmt(7 downto 4)) )) nand Reg( to_integer(unsigned(Kmt(3 downto 0)) )) ;




	-- ORGATEr	REGISTERLARI OR'LAYIP RAME YAZMA ISLEMI
	When "1101" =>
		Ram( to_integer(unsigned(Kmt(11 downto 8))) ) <=  Reg( to_integer(unsigned(Kmt(7 downto 4)) )) or Reg( to_integer(unsigned(Kmt(3 downto 0)) )) ;




	-- NORGATEr	REGISTERLARI NOR'LAYIP RAME YAZMA ISLEMI
	When "1110" =>
		Ram( to_integer(unsigned(Kmt(11 downto 8))) ) <=  Reg( to_integer(unsigned(Kmt(7 downto 4)) )) nor Reg( to_integer(unsigned(Kmt(3 downto 0)) )) ;




	-- XORGATEr	REGISTERLARI XOR'LAYIP RAME YAZMA ISLEMI
	When "1111" =>
		Ram( to_integer(unsigned(Kmt(11 downto 8))) ) <=  Reg( to_integer(unsigned(Kmt(7 downto 4)) )) xor Reg( to_integer(unsigned(Kmt(3 downto 0)) )) ;



 	When others => 
	    null;
      end case; 
   end if;
end Process;

end struct;