## Requisitos cliente

Es una colección NFT de 1440 piezas en ETH. El nombre Smart Contract: MAR ABIERTO NON FUNGIBLE TIME
Acrónimo: MANF
Royalties: 5% -> En marketplace Open Sea
Minteo: Hay 3 fases
-Team interno Croonos: Hay que enviar 140 NFT en orden a la wallet. Falta wallet de envio
-Free mint: 300 nft que mintearan en la web, es como una private sale pero gratis, solo pagarán el gas fee .Limite de NFTs por wallet de 3. Falta listado de wallets.
-Public Mint: 1000 NFT a 0,08 ETH

No pueden aparecer las properties hasta que se haga el reveal

Wallet madre colección/contrato: 0x50Def171796AF77Fb9313B35BF9cDd3bCd1Ff690

Wallets para sacar los fondos del smart contract (necesitan que firmen si o si las 2 wallets, si solo firma 1 no se puede sacar el dinero):
0x09b6584de8b5DAd1b60ec1c447DD6F11e6B2198a
0x8Dd6AeF76c8A8Bc24e8F3EDF88Dc38f164C546c5

Es un proyecto un poco especial, por lo que en Open Sea, una vez minteado los 1440 NFT, si la gente lo filtra por Oldest y lo ponen en formato mosaico, tienen que ir en orden de los NFT desde el 1 al 1440, ya que formaran un collage todos juntos.

## Flujo de trabajo

- Testear que la funcionalidad core requerida funciona como esta planteado

  - unit test para cada funcionalidad
  - testear en opensea testnet y hacer captura de que los nft se muestran en orden
  - documento de posibles mejoras de funcionalidad
    ( merkle tree para whitelist, estandar 2981 para royalties... )

- Revision conjunta antes de enviar documento al cliente
