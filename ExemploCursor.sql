DECLARE CursorTeste CURSOR
	
	FAST_FORWARD
		FOR SELECT TOP 100 
			F.FILI_NM_FANTASIA,
			F.ESTA_SG_UF, 
			PF.PRME_CD_PRODUTO, 
			PF.PRFI_QT_ESTOQATUAL, 
			PM.PRME_TX_DESCRICAO1 
		FROM FILIAL F INNER JOIN PRODUTO_FILIAL PF 
			ON F.FILI_CD_FILIAL = PF.FILI_CD_FILIAL
			INNER JOIN PRODUTO_MESTRE PM 
				ON PF.PRME_CD_PRODUTO = PM.PRME_CD_PRODUTO
					WHERE PF.PRFI_QT_ESTOQATUAL > 0

	DECLARE @FANTASIA VARCHAR(50)
	DECLARE @UF VARCHAR(2)
	DECLARE @CD_PRODUTO INT
	DECLARE @QT_ESTOQATUAL INT
	DECLARE @DESCRICAO1 VARCHAR(50)
	DECLARE @CONTADOR INT

	OPEN CursorTeste

	SET @CONTADOR = 0
	
	FETCH NEXT FROM CursorTeste
	INTO @FANTASIA, @UF, @CD_PRODUTO, @QT_ESTOQATUAL, @DESCRICAO1
	
	WHILE @@FETCH_STATUS = 0
		
		BEGIN
		
			PRINT 'LINHA ' + CONVERT(VARCHAR,@CONTADOR) + ': ' + CONVERT(VARCHAR,@FANTASIA) + ' | ' + CONVERT(VARCHAR,@UF) + ' | ' + CONVERT(VARCHAR, @CD_PRODUTO) + ' | ' + CONVERT(VARCHAR, @QT_ESTOQATUAL) + ' | ' + @DESCRICAO1
			
			FETCH NEXT FROM CursorTeste
			INTO @FANTASIA, @UF, @CD_PRODUTO, @QT_ESTOQATUAL, @DESCRICAO1
			
			SET @CONTADOR = @CONTADOR + 1
		END

	CLOSE CursorTeste
	DEALLOCATE CursorTeste