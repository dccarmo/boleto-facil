//
//  BFOCodigoBarra.m
//  BoletoFacil
//
//  Created by Diogo do Carmo on 27/04/14.
//  Copyright (c) 2014 Diogo do Carmo. All rights reserved.
//

#import "BFOGerenciadorBoleto.h"

static NSString *fileName = @"barCodes";

@interface BFOGerenciadorBoleto()

@property (nonatomic) NSMutableArray *codigos;

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

- (NSMutableArray *)codigos
{
    if (!_codigos) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
        
        if (fileExists) {
            _codigos = [NSMutableArray arrayWithContentsOfFile:finalPath];
        } else {
            _codigos = [NSMutableArray new];
        }
    }
    
    return _codigos;
}

- (void)setUltimoCodigo:(NSMutableDictionary *)ultimoCodigo
{
    _ultimoCodigo = ultimoCodigo;
}

#pragma mark - Gerenciamento

- (void)adicionarCodigo:(NSString *)codigo
{
    NSMutableDictionary *ultimoCodigo = [NSMutableDictionary dictionaryWithDictionary:@{@"codigo":codigo, @"data":[NSDate date]}];
    
    self.ultimoCodigo = ultimoCodigo;
    [self.codigos addObject:ultimoCodigo];
    [self save];
}

- (NSDictionary *)codigoNoIndice:(NSInteger)indice
{
    return self.codigos[indice];
}

- (NSInteger)quantidadeCodigosArmazenados
{
    return [self.codigos count];
}

- (void)save
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];

    if(![self.codigos writeToFile:finalPath atomically:NO]) {
        NSLog(@"Array wasn't saved properly");
    }
}



@end
