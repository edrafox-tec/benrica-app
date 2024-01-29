export interface ITradeCode {
    id: number;
    nome: string;
    logo: string;
    ativa: 1;
    estado: string | null;
    contato: string;
    aberto_fechado: string,
    descricao: string,
    email: string,
    corTema: string,
    corLetra: string,
    segmento: number,
    quantidade_mesas: number,
    tipo_frete: string,
    valor_frete: string,
    valor_saida: string,
    valor_KM: string,
    maximo_KM: string,
    atende_local: number,
    sistema_fidelidade: number,
    loja_ativa: number,
    bairro: string,
    cep: number,
    endereco: string
}