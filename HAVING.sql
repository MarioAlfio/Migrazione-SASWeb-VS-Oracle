/*Quando in SAS ci troviamo una casistica del genere non possiamo andare semplicemente a sostituire la funzione HAVING, 
perchè la sintassi in SAS è diversa da quella di SQL, quindi abbiamo studiato un modo per tradurre questa funzione. */

PROC SQL;
CREATE TABLE TABELLA AS SELECT DISTINCT
Q.*
FROM
TABELLA_RISULTATI Q
GROUP BY
Q.CAMPO_ID
HAVING Q.CAMPO_ID=MAX(Q.CAMPO_ID)
;QUIT;

--In SQL lo tradurremo nel modo seguente:

SELECT * FROM (
    SELECT F.CAMPO_ID,
       	MAX(TRUNC(F.CAMPO_ID)) OVER (PARTITION BY F.CAMPO_TYPE,F.CAMPO_CODE)  AS CAMPO_ID_MAX,
       	F.CAMPO_TYPE,
       	F.CAMPO_CODE,
       	--ALTRI CAMPI SE PRESENTI
       	F.CAMPO_DATA,
       	MAX(TRUNC(F.CAMPO_DATA)) OVER (PARTITION BY F.CAMPO_TYPE,F.CAMPO_CODE)  AS CAMPO_DATA_MAX,   
    FROM
           TABELLA_PRINCIPALE F
	LEFT JOIN TABELLA_CODES SC ON F.CAMPO_CODE=SC.CAMPO_CODE AND F.CAMPO_CODE=SC.CAMPO_CODE
	WHERE CAMPO='Y'
	) MAX
	WHERE coalesce(TRUNC(MAX.CAMPO_DATA,-999))=coalesce(MAX.CAMPO_DATA_MAX,-999)
	AND coalesce(MAX.CAMPO_ID,-999)=coalesce(MAX.CAMPO_ID_MAX,-999)
),
