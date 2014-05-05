//
//  BFOCodigoBarra.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOGerenciadorBoleto.h"

//Support
#import "DCCBoletoBancarioFormatter.h"
#import "BFOUtilidadesBoleto.h"

static NSString *fileName = @"barCodes";

@interface BFOGerenciadorBoleto()

@property (nonatomic) NSMutableArray *boletos;

@end

@implementation BFOGerenciadorBoleto

+ (id)sharedGerenciadorBoleto
{
    static dispatch_once_t pred;
    static BFOGerenciadorBoleto *gerenciadorBoleto = nil;
    
    dispatch_once(&pred, ^{
        gerenciadorBoleto = [self new];
    });
    
    return gerenciadorBoleto;
}

- (NSMutableArray *)boletos
{
    if (!_boletos) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
        
        if (fileExists) {
            _boletos = [NSMutableArray arrayWithContentsOfFile:finalPath];
        } else {
            _boletos = [NSMutableArray new];
        }
    }
    
    return _boletos;
}

- (void)setUltimoBoleto:(NSMutableDictionary *)ultimoCodigo
{
    _ultimoBoleto = ultimoCodigo;
}

#pragma mark - Gerenciamento

- (void)adicionarCodigoBarras:(NSString *)codigoBarras
{
    NSMutableDictionary *ultimoCodigo;
    DCCBoletoBancarioFormatter *formatoBoleto = [DCCBoletoBancarioFormatter new];
    BFOUtilidadesBoleto *utilidadesBoleto = [BFOUtilidadesBoleto new];
    
    ultimoCodigo = [NSMutableDictionary dictionaryWithDictionary:@{@"codigo":codigoBarras,
                                                                   @"linhaDigitavel":[formatoBoleto linhaDigitavelDoCodigoBarra:codigoBarras],
                                                                   @"banco":[utilidadesBoleto bancoDoCodigoBarras:codigoBarras] ? [utilidadesBoleto bancoDoCodigoBarras:codigoBarras] : @"Banco não identificado",
                                                                   @"dataVencimento":[utilidadesBoleto dataVencimentoDoCodigoBarras:codigoBarras],
                                                                   @"valorExtenso":[utilidadesBoleto valorExtensoDoCodigoBarras:codigoBarras],
                                                                   @"data":[NSDate date]}];
    
    self.ultimoBoleto = ultimoCodigo;
    [self.boletos addObject:ultimoCodigo];
    self.boletos = [NSMutableArray arrayWithArray:[self.boletos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:NO]]]];
    [self save];
}

- (NSDictionary *)boletoNoIndice:(NSInteger)indice
{
    return self.boletos[indice];
}

- (NSInteger)quantidadeCodigosArmazenados
{
    return [self.boletos count];
}

- (void)save
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];

    if(![self.boletos writeToFile:finalPath atomically:NO]) {
        NSLog(@"Array wasn't saved properly");
    }
}

@end
