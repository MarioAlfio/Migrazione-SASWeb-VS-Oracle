/*Quando in SAS ci troviamo davanti la seguente casistica non possiamo andare semplicemente a sostituire 
perchè la sintassi in SAS è diversa da quella in SQL, quindi abbiamo studiato modi per tradurre queste funzioni. */

--LAG in SAS:

DATA COMP_CONT2;
SET COMP_CONT1;
COMPANY_LAG=lag(COMPANY_CODE);
IF _n_ = 1 THEN DO; ID = 1; RETAIN ID; END;
IF _n_ > 1 THEN DO;
IF COMPANY_LAG = COMPANY_CODE THEN DO; ID = ID+1; RETAIN ID; END;
IF COMPANY_LAG ne COMPANY_CODE THEN ID = 1;
END;
RUN;

--In SQL lo tradurremo nel modo seguente:

TABELLA AS
(SELECT CAMPO1,
ROW_NUMBER () .... AS R_NUM
FROM ...
)
SELECT T1.CAMPO1, T2.CAMPO1, ...
FROM TABELLA T1,
TABELLA T2
WHERE T1.R_NUM=T2.R_NUM-1

--COMPRESS in SAS:

COMPRESS(CAMPO_CODE, ,'KW') AS CAMPO_CODE

--In SQL lo tradurremo nel modo seguente:

REGEXP_REPLACE(CAMPO_CODE, '[^[:print:]]', '')  AS CAMPO_CODE
 
--DATEPART in SAS:
DATEPART(CAMPO_DATA)

--In SQL lo tradurremo nel modo seguente:

TRUNC(CAMPO_DATA)

--Molto utili quando in SAS troviamo operazioni con YEAR E MONTH:
ADD_MONTHS(SYSDATE,-5*12)
ROUND(MONTHS_BETWEEN(TRUNC(STATUS_DATE), SYSDATE))<=17
 

--CATX in SAS:
CATX('+', CAMPO_PRIMARIA, CAMPO_SECONDARIA)
----> se CAMPO__SECONDARIA è null il risultato dell'espressione è il solo valore di CAMPO_PRIMARIA
 
--In SQL lo tradurremo nel modo seguente:
CASE WHEN CAMPO_SECONDARIA IS NULL THEN CAMPO_PRIMARIA ELSE trim(CAMPO_PRIMARIA)||'+'||trim(CAMPO_SECONDARIA)



--CASO DA CONSIDERARE QUANDO TROVO UNA TRASPOSE STATICA IN SAS, LO TRADUCIAMO IN SQL:

SELECT CAMPO_ID,
       MAX(CASE WHEN CAMPO_CODE = 'MAN' THEN CAMPO_DESC END) AS CAMPO_MAN,
	   MAX(CASE WHEN CAMPO_CODE = 'MAN1' THEN CAMPO_DESC END) AS CAMPO_MAN1,
FROM TABELLA
WHERE CAMPO_CODE IN ('MAN','MAN1')
GROUP BY CAMPO_ID
),

