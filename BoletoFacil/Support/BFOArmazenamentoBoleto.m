//
//  BFOCodigoBarra.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOArmazenamentoBoleto.h"

//Models
#import "BFOBoleto.h"

@interface BFOArmazenamentoBoleto() {
    NSMutableArray *_boletos;
}

@end

@implementation BFOArmazenamentoBoleto

+ (instancetype)sharedArmazenamentoBoleto
{
    static dispatch_once_t pred;
    static BFOArmazenamentoBoleto *gerenciadorBoleto = nil;
    
    dispatch_once(&pred, ^{
        gerenciadorBoleto = [self new];
    });
    
    return gerenciadorBoleto;
}

#pragma mark - BFOArmazenamentoBoleto

- (NSMutableArray *)boletos
{
    if (!_boletos) {
        _boletos = [NSKeyedUnarchiver unarchiveObjectWithFile:[self caminhoArquivo]];
        
        if (!_boletos) {
            _boletos = [NSMutableArray new];
        }
    }
    
    return _boletos;
}

- (BFOBoleto *)adicionarBoletoComCodigoBarras:(NSString *)codigoBarras
{
    BFOBoleto *boleto;
    
    boleto = [self boletoComCodigoBarras:codigoBarras];
    
    if (!boleto) {
        boleto = [[BFOBoleto alloc] initWithCodigoBarras:codigoBarras];
        [_boletos addObject:boleto];
        
        [self salvar];
    }
    
    return boleto;
}

- (void)removerBoleto:(BFOBoleto *)boleto
{
    for (UILocalNotification *lembrete in boleto.lembretes) {
        [[UIApplication sharedApplication] cancelLocalNotification:lembrete];
    }
    
    [_boletos removeObject:boleto];
   
    [self salvar];
}

- (BFOBoleto *)boletoComCodigoBarras:(NSString *)codigoBarras
{
    for (BFOBoleto *boleto in self.boletos) {
        if ([boleto.codigoBarras isEqualToString:codigoBarras]) {
            return boleto;
        }
    }
    
    return nil;
}

- (NSString *)caminhoArquivo
{
    NSString *pastaDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    return [pastaDocuments stringByAppendingPathComponent:@"boletos.archive"];
}

- (void)salvar
{
    if (![NSKeyedArchiver archiveRootObject:self.boletos toFile:[self caminhoArquivo]]) {
        NSLog(@"Erro ao salvar boletos");
    }
}

@end
