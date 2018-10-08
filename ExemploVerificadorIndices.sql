USE xxxx
GO

SET DATEFORMAT DMY
SET QUOTED_IDENTIFIER OFF

-- ENTRADA
DECLARE @PERIODO_INI INT -- 201801
DECLARE @PERIODO_FIN INT -- 201801

DECLARE @SQL01 VARCHAR(255)
DECLARE @SQL02 VARCHAR(255)
DECLARE @SQL03 VARCHAR(255)
DECLARE @SQL04 VARCHAR(255)

DECLARE @NOMEBANCO VARCHAR(255)
DECLARE @PERIODO_AUX INT

DECLARE @DATA_INI DATETIME
DECLARE @DATA_FIN DATETIME

SET @PERIODO_INI = 201301
SET @PERIODO_FIN = 201805
SET @PERIODO_AUX = @PERIODO_INI

SET @NOMEBANCO = "xxx" + CONVERT(VARCHAR(6),@PERIODO_INI) -- NOME DO BANCO + PERIODO

WHILE @@FETCH_STATUS = 0 AND @PERIODO_AUX <= @PERIODO_FIN
BEGIN
	
	IF(SELECT COUNT(*) FROM MASTER..SYSDATABASES WHERE NAME = @NOMEBANCO) = 0
	BEGIN
		RETURN
	END
	ELSE
	BEGIN
		
		SET @SQL01 = "IF (SELECT COUNT(*) FROM " + @NOMEBANCO + ".SYS.INDEXES WHERE NAME = 'XPKTRANSF_CAB_ANTERIOR') > 0 " + CHAR(13) +
					 "BEGIN " + CHAR(13) +
						"SELECT '" + @NOMEBANCO + "' + ' - ' + 'TRANSF_CAB TEM INDICE' " + CHAR(13) +
					 "END "
		SET @SQL02 = "ELSE " + CHAR(13) +
					 "BEGIN " + CHAR(13) +
						"SELECT '" + @NOMEBANCO + "' + ' - ' + 'TRANSF_CAB N�O TEM INDICE' " + CHAR(13) +
					 "END "
    
		SET @SQL03 = "IF (SELECT COUNT(*) FROM " + @NOMEBANCO + ".SYS.INDEXES WHERE NAME = 'XPKTRANSF_DET_ANTERIOR') > 0 " + CHAR(13) +
					 "BEGIN " + CHAR(13) +
						"SELECT '" + @NOMEBANCO + "' + ' - ' + 'TRANSF_DET TEM INDICE' " + CHAR(13) +
					 "END "
		SET @SQL04 = "ELSE " + CHAR(13) +
					 "BEGIN " + CHAR(13) +
						"SELECT '" + @NOMEBANCO + "' + ' - ' + 'TRANSF_DET N�O TEM INDICE' " + CHAR(13) +
					 "END "

		EXEC(@SQL01 + @SQL02 + @SQL03 + @SQL04)
	END

	SET @DATA_INI = "01/" + RIGHT(CONVERT(VARCHAR(10),@PERIODO_AUX),2) + "/" + LEFT(CONVERT(VARCHAR(10),@PERIODO_AUX),4)
	SET @DATA_FIN = EOMONTH(@DATA_INI,1)

	SET @PERIODO_AUX = LEFT(CONVERT(VARCHAR(10),@DATA_FIN,112),6)
	SET @NOMEBANCO = "xxx" + CONVERT(VARCHAR(6),@PERIODO_AUX)
END