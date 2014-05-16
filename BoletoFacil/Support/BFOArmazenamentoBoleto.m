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
