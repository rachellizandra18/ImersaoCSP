public class PDFPagamentoExtension { //criar classe de teste
    
    private Pagamento__c pagamento;
    public List<Attachment> existingAttLst { get; set; }
    public List<ContentVersion> existingContentLst { get; set; }
    public Blob pdfBlob;
	
    public PDFPagamentoExtension(ApexPages.StandardController stdController) {
        this.pagamento = (Pagamento__c) stdController.getRecord();
    }
    
    
    public Decimal getValorBoleto() {
        Id pagamentoId = this.pagamento.Id;
        
        AggregateResult[] agrupamentoViagem = [SELECT SUM(Custo__c) custo
                                         FROM Viagem__c
                                         WHERE Pagamento__c = :pagamentoId];
        
        Decimal totalCustoViagem = (Decimal) agrupamentoViagem[0].get('custo');
        
        AggregateResult[] agrupamentoDespesa = [SELECT SUM(Custo__c) custo
                                         FROM Despesa__c
                                         WHERE Pagamento__c = :pagamentoId];
        
        Decimal totalCustoDespesa = (Decimal) agrupamentoDespesa[0].get('custo');
        
        if(totalCustoDespesa == null) {
            totalCustoDespesa = 0;
        }
        
        if (totalCustoViagem == null) {
            totalCustoViagem = 0;
        }
        
        return totalCustoViagem + totalCustoDespesa;

    }
    
    	public PageReference attachPDF() {
		
		PageReference pdfPage = Page.PDFPagamento;
        pdfPage.getParameters().put('id', this.pagamento.Id);
            
            
		if (!Test.isRunningTest()) {            
                
            try {
				this.pdfBlob = pdfPage.getContent(); 
            }
            catch (Exception e) {
                this.pdfBlob = Blob.valueOf(e.getMessage());
            }
            
                
            /*List<ContentVersion> lstCV = [SELECT Id, ContentDocumentId, Title, VersionData FROM ContentVersion WHERE Pagamento__c = :this.pagamento.Id];
                
                if(lstCV.size() == 0) {
                    List<ContentDocumentLink> cdls = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :this.pagamento.Id];
                    Set<Id> cdIds = new Set<Id>();
                    for(ContentDocumentLink cdl : cdls) {
                        cdIds.add(cdl.ContentDocumentId);
                    }
                    lstCV = [SELECT Id, ContentDocumentId, Title, VersionData FROM ContentVersion WHERE ContentDocumentId IN :cdIds];
                    
                      for(ContentVersion cVersion : lstCV) {
                         cVersion.ContentLocation = 'S';
                         cVersion.Title = 'Boleto - ' + this.pagamento.Cliente__r.Name;
                         cVersion.PathOnClient = cVersion.Title + '.pdf';
                         cVersion.VersionData = this.pdfBlob; //converte o arquivo de string para pdf
                         insert cVersion;
                    }
                            
                }  */                      
                            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S';
            cVersion.Title = 'Boleto - ' + this.pagamento.Cliente__r.Name;
            cVersion.PathOnClient = cVersion.Title + '.pdf';
            cVersion.VersionData = this.pdfBlob; //converte o arquivo de string para pdf
            insert cVersion;
            
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].contentDocumentId;
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;
            cDocLink.LinkedEntityId = this.pagamento.Id; //Id do objeto
            cDocLink.Visibility = 'AllUsers'; // visibilidade para todos os usuários
            cDocLink.ShareType = 'V'; //permissão de apenas visualizar "V"
            insert cDocLink;                
           
            //System.debug('Documento já anexado.');
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Documento já anexado.'));
    


            
		} else {
			this.pdfBlob = Blob.valueOf('Texto de teste para arquivo PDF...');
		}
                       
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'PDF gerado e anexado com sucesso.'));
		
		//redirect the user
		//PageReference pageWhereWeWantToGo = new ApexPages.StandardController(this.pagamento).view(); //we want to redirect the User back to the Account detail page
		//pageWhereWeWantToGo.setRedirect(true); //indicate that the redirect should be performed on the client side
		//return pageWhereWeWantToGo; //send the User on their way
		return pdfPage;
	}
    
    public PageReference sendEmail(){
        
        Pagamento__c pagamentoWithClientEmail = [SELECT Id, Cliente__r.Email__c FROM Pagamento__c WHERE Id = :this.pagamento.Id LIMIT 1];
        
        if (pagamentoWithClientEmail != null && pagamentoWithClientEmail.Cliente__r.Email__c != null) {
        String email = pagamentoWithClientEmail.Cliente__r.Email__c;
        List<String> emails = new List<String>();
        emails.add(email);
        
        PageReference pdfPage = Page.PDFPagamento;
        pdfPage.getParameters().put('id', this.pagamento.Id);
        this.pdfBlob = pdfPage.getContentAsPDF(); 
               
        // Create email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(emails);
        message.setSubject('Resumo de pagamento para ' + this.pagamento.Cliente__r.Name);
        message.setHtmlBody('Segue o resumo de pagamento e o boleto para ' + this.pagamento.Cliente__r.Name + '. Dúvidas, retornar este email.');
        
        // Attach PDF to email and send
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('Resumo do pagamento -' + this.pagamento.Cliente__r.Name + '.pdf');
        attachment.setInline(false);
        attachment.setBody(this.pdfBlob);
        message.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ message });
        
        ApexPages.addMessage(new 
            ApexPages.Message(ApexPages.Severity.INFO,
           'Email enviado com anexo em PDF para ' + email)); 
                        
        } else {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, 'Email do cliente não encontrado.'
            ));
        }                

		PageReference pageWhereWeWantToGo = new ApexPages.StandardController(this.pagamento).view(); 
		pageWhereWeWantToGo.setRedirect(true);
		return pageWhereWeWantToGo;    	
    
    }    
	
    /*public void savePdf() {
        
        // Recuperar o conteúdo do PDF da variável view state
        String pdfContent = EncodingUtil.base64Encode(this.pdfContent);
        
        // Converte o conteúdo base64 de volta para Blob
        Blob pdfBlob = EncodingUtil.base64Decode(pdfContent);
        
        //String testData = 'this will be stored in pdf'; //deve conter o arquivo do boleto
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S';
        cVersion.Title = 'PDFPagamento';
        cVersion.PathOnClient = cVersion.Title + '.pdf';
        cVersion.VersionData = pdfBlob; //converte o arquivo de string para pdf
        insert cVersion;
        
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].contentDocumentId;
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;
        cDocLink.LinkedEntityId = this.pagamento.Id; //Id do objeto
        cDocLink.Visibility = 'AllUsers'; // visibilidade para todos os usuários
        cDocLink.ShareType = 'V'; //permissão de apenas visualizar "V"
        insert cDocLink;
    }*/
    
    /*public PageReference gerarPDF() {
        // Recuperar o conteúdo do PDF da variável view state
        String pdfContent = EncodingUtil.base64Encode(this.pdfContent);
        
        // Converte o conteúdo base64 de volta para Blob
        Blob pdfBlob = EncodingUtil.base64Decode(pdfContent);
        
    // Lógica para gerar o PDF
    //String pdfContent = 'Conteúdo do PDF gerado'; // Substitua pelo conteúdo real do PDF
    //pdfContent = EncodingUtil.base64Encode(Blob.valueOf(pdfContent)); // Converter para base64
    this.pdfContent = pdfBlob;
        
    savePdf();
    return null;
}*/
    
    
    
}