<?php namespace Api;
/**
 ** Classe responśvel pelos processos do BD e calculos
 *
 ********* geratePoke ************
 * Gera um pokemon de acordo com o mold
 * @param Int $idMold [Id do mold do pokemon, Ex:Charmander id=4]
 * @param Int $lv [Nivel do pokemon que vai ser gerado]
 * @param Int $prob[probabilidade de shiny, de 1 a 1000]
 *
 * @return Array $poke [dados do pokemon gerado]
 * @return Boolean false [caso algo de errado, e nada sera alterado]
 *
 * @Exemplo $this->pro->geratePoke($idMold,$lv,$prob);
 *
 ********* setPoke *********
 * Guarda um pokemon no BD, e ativa um ação relacional de acordo com a variavel:
 * @param Int $idPlayer [Id do jogador no qual sera relacionado o pokemon]
 * @param Array $poke [Array completo do pokemon]
 * @param Int $action [
 *    0 = relacionar o pokemon com as tabelas pokemonPlayer && bag
 *    1 = relacionar o pokemon com as tabelas pokemonPlayer && bank
 *    2 = relacionar o pokemon com a tabela rival
 *  ]
 *
 * @return Boolean true ? false
 *
 * @Exemplo $this->pro->setPoke($idPlayer,$poke,$action);
 *
 *
 */

class Process {
	/**
  * link do calculo link calculo: https://bulbapedia.bulbagarden.net/wiki/Statistic
  * link para testar: https://pokemonshowdown.com/damagecalc/
	*/
  // private $log;
  // private $IV;
  // private $bd;

  public function __construct(){
    $this->bd = new DataAccessMySQL('poke');
    $this->log['error'] = false;
    $this->IV = 0;
  }

  /** getXp
  * Esta função calcula a quantidade de XP adquirida
  * Recebe um Array de variaveis de calculo e retorna o resultado
  * @return Array $variableXP[Variriáveis do sistema de XP]:
  *
  * @return Int [quantidade de XP adquirido]
  *
  * @Exemplo $this->pro->levelUp($poke);
  */
  //getXp
  /* Descrição $v
  a = {
    1 se o Pokémon desmaiado é selvagem
    1.5 se o Pokémon desmaiado é de propriedade de um treinador
  }

  b = {
    recompensa de XP de acordo com o pokemon derrotado
  }

  e = {
    1.5 se o Pokémon vencedor estiver segurando um Lucky Egg
    1 caso contrário
  }

  f = {
    1.2 se o Pokémon tiver um afeto de dois corações ou mais
    1 caso contrário
  }

  l = {
    level do pokemon derrotado
  }

  t = {
    1 se o atual proprietário do Pokémon vencedor for seu treinador original
    1.5 se o Pokémon foi ganho em um comércio interno
    Geração IV + somente : 1.7 se o Pokémon foi ganho em um comércio internacional
  }
  */
  function getXp($v){
    $ext = ($v['a']*$v['t']*$v['b']*$v['e']*$v['l']*$v['f']);
    return intVal($ext/(7*$v['s']));
  }//getXP

  /** getLimitLevel
  * Esta função recebe o lv e Leveling e retorna quando de xp deve superar para
  * avançar de nível
  * de acordom o leveling rate
  *
  * @link https://bulbapedia.bulbagarden.net/wiki/Experience
  *
  * @param Int $lv [level do qual quer calcular o limite]
  * @param Int $lr [Leveling rate]
  *
  * @return Int $poke [dados do pokemon pós processo]
  *
  * @Exemplo $this->pro->getLimitLevel(5,'ms');
  */
  //getLimitLevel
  /* Descrição Leveling rate
  Leveling rate(lr) {
    0 - (e)Erratic
    1 - (f)Fest
    2 - (mf)MediumFest
    3 - (ms)MediumSlow
    4 - (s)Slow
    5 - (fl)Fluctuating
  }
  */
  function getLimitLevel($lv,$lr){
    //se for Erratic
    if($lr == 'e'){
      //inicio do calculo
      $n = pow($lv,3);
      //se lv for menor que 50
      if($lv < 50){
        $n2 = (100-$lv);
        $n  = ($n*$n2);
        $n  = ($n/50);
        $n =($n);
      // se lv for maior que 50 e menor que 68
      }elseif($lv >= 50 && $lv < 68){
        $n2 = (150-$lv);
        $n  = ($n*$n2);
        $n  = ($n/100);
        $n = ($n);
      // se lv for maior que 68 e menor que 98
      }elseif($lv >= 68 && $lv < 98){
        // $n2 = (10*$lv);
        $m  = (10*$lv);
        $n2 = (1911-($m));
        $n2 = (($n2)/3);
        $n  = ($n*$n2);
        $n  = ($n/500);
        $n = ($n);
      // se lv for maior ou igual a 98 e menor que 100
    }elseif($lv >= 98 && $lv <= 100){
        // $n2 = (10*$lv);
        $n2 = (160-($lv));
        $n  = ($n*$n2);
        $n  = ($n/100);
        $n = ($n);
      }
    }//if($lr == 'e')
    //se for fast
    elseif($lr == 'f'){
      $n = (4*(pow($lv,3))/(5));
    }
    //se for medium fast
    elseif($lr == 'mf'){
      $n = pow($lv,3);
    }
    //se for medium slow
    elseif($lr == 'ms'){
      $n = ( (1.2)*(pow($lv,3)) - (15*(pow($lv,2)) ) + (100*$lv) - 140 );
    }
    //se for slow
    elseif($lr == 's'){
      $n = (5*(pow($lv,3))/(4));
    }
    //se for Fluctuating
    elseif($lr == 'fl'){
      //iniciando cálculo
      $n = pow($lv,3);
      //se for level menor que 15
      if($lv < 15){
        $n2 = (($lv+1)/3);
        $n2 = $n2+24;
        $n2 = $n2/50;

        $n = (($n)*($n2));
      }
      //se for level maior que 14 e menor que 36
      elseif($lv >= 15 && $lv < 36){
        $n2 = (($lv+14)/50);
        $n = $n*$n2;
      }
      //se for level maior que 35
      elseif($lv > 35){
        $n2 = ( ( ($lv/2)+32 )/50 );
        $n = $n*$n2;
      }
    }//fl
    return intval($n);
  }//getLimitLevel

  /** levelUp
  * Acrescentar o nivel do pokemon e ou Evoluir
  * Recebe os dados do pokemon, e verifica se deve evoluir de nivel
  * @param Array $poke [dados do pokemon]
  *
  * @return Array $poke [dados do pokemon pós processo]
  *
  * @Exemplo $pro->verifyLevelUp($poke);
  */
  function verifyLevelUp($poke){
    //verificar qual o limite para o prox nivel de acordo com lr
    $limitLevel = $this->getLimitLevel($poke['level'],$poke['lr']);
    //verifica se deve ir para o proximo nivel
    if($poke['xp'] > $limitLevel){
      //$poke['xp'] = (($poke['xp'])-($limitLevel));
      //verifica se o pokemon evolue no prox nivel
      if( ($poke['level']+1) == ($poke['levelEvolution']) ){
        //evoluir, atribuir status originais ao pokemon
        // $poke = $this->setStatusEvolution($poke, $poke['level']+1);
        $r = 2;
      }else{
        //apenas subir de nivel
        // $poke = $this->setStatus($poke);
        $r = 1;
      }//else
      // $r['poke'] = $poke;
      // return $r;
    }//if($poke['xp'] > $limitLevel)
    return 0;
  }//levelUp

  /** addXP
  * Acrescenta o ganho de XP
  * retorna a quantidade de Xp do pokemon especifico somando com calculo de XP
  * @link https://bulbapedia.bulbagarden.net/wiki/Experience
  *
  * @param Int    $idPokemon [Id do pokemon]
  *
  * @return Array $variableXP[Variriáveis do sistema de XP]
  * @return Boolean 0 [caso o pokemon seja lv 100]
  * @return Boolean false [caso algo de errado]
  *
  * @Exemplo $this->pro->addXP(
  *   10001,['a'=>1,'b'=>39,'e'=>1,'f'=>1,'l'=>16,'s'=>2,'t'=>1]
  * );
  */

  /* Descrição das variáveis
  a = {
    1 se o Pokémon desmaiado é selvagem
    1.5 se o Pokémon desmaiado é de propriedade de um treinador
  }

  b = {
    recompensa de XP de acordo com o pokemon derrotado
  }

  e = {
    1.5 se o Pokémon vencedor estiver segurando um Lucky Egg
    1 caso contrário
  }

  f = {
    1.2 se o Pokémon tiver um afeto de dois corações ou mais
    1 caso contrário
  }

  l = {
    level do pokemon derrotado
  }

  t = {
    1 se o atual proprietário do Pokémon vencedor for seu treinador original
    1.5 se o Pokémon foi ganho em um comércio interno
    Geração IV + somente : 1.7 se o Pokémon foi ganho em um comércio internacional
  }
  */
  function addXP($poke,$variablesXP){
    /*
    //pega o poke !* Verificar se esse pokemon pertence a esse jogador
    $poke = $this->getPoke($idPoke);
    //verifica se o array esta vazio, jogador sem pokemon
    if( empty( $poke ) ){
      //guarda o erro, para ser retornado
      // $title,$function,$line,$objective,$msg)
      $this->setLog(
       'error_in_getPoke',
       'addXP',
       __LINE__,
       'try get poke in table_pokemon',
       'Pokemon not exist in table_pokemon'
      );
      return false;
    }*/

    //se o pokemon for lv 100, nada a fazer.
    if($poke['level'] == 100){
      return 0;
    }//if
    //quantidade de XP que foi adquirido
    $gainXP = $this->getXp($variablesXP);
    //adiciona XP no pokemon
    $xp = (($poke['xp'])+($gainXP));
    return $xp;
    // //iniciando classe de update
    // $up = new Update();
    // //tenta atualizar o XP
    // if(!$up->updatePoke($idPoke,['xp'=>$xp])){
    //   return false;
    // }//if
    // return true;
  }//addXP

  /** processXP
  * Acrescenta o ganho de XP
  * @link https://bulbapedia.bulbagarden.net/wiki/Experience
  * verifica se o XP total do poke é suficiente para evoluir
  * de nivel, se sim, acrescentar nivel e ou evoluir o pokemon.
  * no final do processo verificar se ainda há XP suficiente para
  * avançar para o proximo nivel, se sim, fazer o processo novamente
  *
  * @param Int    $idPokemon [Id do pokemon]
  * @return Array $variableXP[Variriáveis do sistema de XP]
  *
  * @return Array $status [dados do pokemon]
  * @return Int   (0) retorna 0 em caso de pokemon sem status
  * @return Boolean 0 [caso o pokemon seja lv 100]
  * @return Boolean false [caso algo de errado]
  *
  * @Exemplo $this->pro->processXP(
  *   10001,['a'=>1,'b'=>39,'e'=>1,'f'=>1,'l'=>16,'s'=>2,'t'=>1]
  * );
  */
  //processXP
  /* Descrição das variáveis
  a = {
    1 se o Pokémon desmaiado é selvagem
    1.5 se o Pokémon desmaiado é de propriedade de um treinador
  }

  b = {
    recompensa de XP de acordo com o pokemon derrotado
  }

  e = {
    1.5 se o Pokémon vencedor estiver segurando um Lucky Egg
    1 caso contrário
  }

  f = {
    1.2 se o Pokémon tiver um afeto de dois corações ou mais
    1 caso contrário
  }

  l = {
    level do pokemon derrotado
  }

  t = {
    1 se o atual proprietário do Pokémon vencedor for seu treinador original
    1.5 se o Pokémon foi ganho em um comércio interno
    Geração IV + somente : 1.7 se o Pokémon foi ganho em um comércio internacional
  }
  */
  function __processXP($idPoke,$variablesXP){
    //informações de retorno
    $info['levelUp'] = false;

    $poke = $this->getPoke($idPoke);
    // $poke['xp'] = 2035;
    //param ===============
    //se o pokemon for lv 100, nada a fazer.
    if($poke['level'] == 100){
      return 0;
    }
    //verifica a quantidade de XP que foi adquirido
    $gainXP = $this->getXp($variablesXP);
    // * verificar qual o limite para o prox nivel de acordo com lr
    $limitLevel = $this->getLimitLevel($poke['level'],$poke['lr']);

    // * adiciona XP no pokemon
    $oldXp = $poke['xp'];
    $poke['xp'] = (($poke['xp'])+($gainXP));
    //iniciando classe de update
    $up = new Update();
    //verifica se deve ir para o proximo nivel
    if($poke['xp'] > $limitLevel){
      //subir de nivel
      $info['levelUp'] = true;
      $pokeUp = $this->levelUp($poke);
      $pokeUp['xp'] = (($pokeUp['xp'])-($limitLevel));
      // return $pokeUp['idType2'];
      if(!$up->updatePoke($idPoke,$pokeUp)){
        return false;
      }//if
    }else{//apenas ganhou XP
      if( !$up->updatePoke($idPoke,['xp' => $poke['xp']]) ) {
        return false;
      }//if
    }//else
    return $info;
  }//processXP

  /** levelUp
  * Acrescentar o nivel do pokemon ou e evoluí-lo.
  * Recebe os dados do pokemon, e verifica se deve evoluir
  * @param Array $poke [dados do pokemon]
  *
  * @return Array $poke [dados do pokemon pós processo]
  *
  * @Exemplo $this->pro->levelUp($poke);
  */
  function __levelUp($poke){
    //verifica se o pokemon evolue no prox nivel
    if( ($poke['level']+1) == ($poke['levelEvolution']) ){
      //evoluir, atribuir status originais ao pokemon
      $poke = $this->setStatusEvolution($poke);
      return $poke;
    }else{//apenas subir de nivel
      $poke = $this->setStatus($poke);
      return $poke;
    }//else
  }//levelUp

  /** setStatus
  * Aumenta o nivel do pokemon(+1)
  * atribui os 6 status base no pokemon de acordo com o idMold
  * Apenas pokemon que será evoluido
  * @param Array $poke [dados do pokemon]
  *
  * @return Array $poke [dados do pokemon pós processo]
  *
  * @Exemplo $this->pro->setStatus($poke);
  */
  function setStatus($poke){
    //!* getMold
    $mold = $this->getMold($poke['idMold']);
    $i  = ( json_decode($poke['info'],true) );
    $lv = $poke['level']+1;

    $poke['hp'] = $this->gerateStatusStatic('hp',$mold['hp'],$lv,
    $i['hp']['iv'],$i['hp']['ev']);
    $poke['atk'] = $this->gerateStatusStatic('st',$mold['atk'],$lv,
    $i['atk']['iv'],$i['atk']['ev']);
    $poke['def'] = $this->gerateStatusStatic('st',$mold['def'],$lv,
    $i['def']['iv'],$i['def']['ev']);
    $poke['spAtk'] = $this->gerateStatusStatic('st',$mold['spAtk'],$lv,
    $i['spAtk']['iv'],$i['spAtk']['ev']);
    $poke['spDef'] = $this->gerateStatusStatic('st',$mold['spDef'],$lv,
    $i['spDef']['iv'],$i['spDef']['ev']);
    $poke['speed'] = $this->gerateStatusStatic('st',$mold['speed'],$lv,
    $i['speed']['iv'],$i['speed']['ev']);
    $poke['level'] = $lv;
    return $poke;
  }//setStatus

  /** setStatusEvolution
  * Evolue o pokemon
  * atribui TODOS status no pokemon(*tabela pokemon) de acordo com o idEvolution
  * Apenas pokemon que será evoluido
  * @param Array $poke [dados do pokemon]
  *
  * @return Array $poke [dados do pokemon pós processo]
  *
  * @Exemplo $this->pro->setStatusEvolution($poke);
  * Obs: Não Adiciona nivel no pokemon
  */
  function setStatusEvolution($poke, $lv){
    //pega a tabela de mold do pokemon
    $mold = $this->getMold($poke['idEvolution']);

    //salva os novos dados no array
    //$lv = $poke['level']+1;
    $poke['name'] = $mold['name'];
    $poke['idMold'] = $mold['idMold'];
    $poke['idType1'] = $mold['idType1'];
    $poke['idType2'] = $mold['idType2'];
    $poke['idEvolution'] = $mold['idEvolution'];
    $poke['levelEvolution'] = $mold['levelEvolution'];
    $poke['level'] = $lv;
    //$poke['idMold'] = $mold['idPokemon'];

    //pega as informações do pokemon, que esta em json
    $i = ( json_decode($poke['info'],true) );
    //realiza os cálculos em cada atributo de acordo om o IV
    $poke['hp'] = $this->gerateStatusStatic('hp',$mold['hp'],$lv,
    $i['hp']['iv'],$i['hp']['ev']);
    $poke['atk'] = $this->gerateStatusStatic('st',$mold['atk'],$lv,
    $i['atk']['iv'],$i['atk']['ev']);
    $poke['def'] = $this->gerateStatusStatic('st',$mold['def'],$lv,
    $i['def']['iv'],$i['def']['ev']);
    $poke['spAtk'] = $this->gerateStatusStatic('st',$mold['spAtk'],$lv,
    $i['spAtk']['iv'],$i['spAtk']['ev']);
    $poke['spDef'] = $this->gerateStatusStatic('st',$mold['spDef'],$lv,
    $i['spDef']['iv'],$i['spDef']['ev']);
    $poke['speed'] = $this->gerateStatusStatic('st',$mold['speed'],$lv,
    $i['speed']['iv'],$i['speed']['ev']);
    return $poke;
  }//setStatusEvolution

  /** getIdPokemonBagByAlive
  * recebe o idPlayer e o primeiro pokemon da posição
  * idPokemon daquela posição
  * @param Int $idPlayer [Id do jogador]
  *
  * @return Int   retorna o idPokemon (se for 0 array vazio)
  * @return Boolean false [caso algo de errado]
  *
  * @Exemplo $this->pro->getPokemonBagByPosition(1,0);
  */
  function getIdPokemonBagByAlive($idPlayer){
    $bd = new DataAccessMySQL('poke');
    $r = $bd->mountSelect('pokemonPlayer pp','pp.idPokemon')
      ->innerJoin('pokemonBag pb','pb.idPokemonPlayer = pp.idPokemonPlayer')
      ->innerJoin('actualStatus a','a.idPokemon = pp.idPokemon')
      ->where([
        ['pp.idPlayer','=',$idPlayer],
        ['a.hp', '>','0']
      ])
      ->orderBy('pb.idPosition','ASC')
      ->limit(1)
      ->execute();
    if( $r != false){
      //verifica se o array esta vazio, jogador sem pokemon
      if( empty( $r['list'] ) ){
        return 0;
      }
      return $r['list'][0]['idPokemon'];
    }
    //guarda o erro, para ser retornado
    $this->setLog(
     'Process.php',
     'getPokemonBagByAlive',
     __LINE__,
     'select_table => pokemonPlayer,actualStatus',
     $bd->getError()
    );
    return false;
  }//getStatusRival

  /** getPokemonBagByPosition
  * recebe o idPokemon e o idPosition, e retorna o
  * idPokemon daquela posição
  * @param Int $idPlayer [Id do jogador]
  * @param Int $idPosition [Nº da ordem de 0 a 5]
  *
  * @return Int   retirna o idPokemon
  * @return Boolean false [caso algo de errado]
  *
  * @Exemplo $this->pro->getPokemonBagByPosition(1,0);
  */
  function getPokemonBagByPosition($idPlayer,$idPosition){
    $bd = new DataAccessMySQL('poke');
    $r = $bd->mountSelect('pokemonPlayer pp','pp.idPokemon')
      ->innerJoin('pokemonBag pb','pb.idPokemonPlayer = pp.idPokemonPlayer')
      ->where([
        ['pp.idPlayer',   '=',$idPlayer],
        ['pb.idPosition', '=',$idPosition]
      ])
      ->execute();
    if( $r != false){
      //verifica se o array esta vazio, jogador sem pokemon
      if( empty( $r['list'] ) ){
        return 0;
      }
      return $r['list'][0]['idPokemon'];
    }
    //guarda o erro, para ser retornado
    $this->setLog(
     'Process.php',
     'getIdMainPokemon',
     __LINE__,
     'select_table => pokemonPlayer',
     $bd->getError()
    );
    return false;
  }//getStatusRival

  /** getStatusPokemon
  * Pega o status do pokemon de acordo com o idPokemon
  * @param Int $idPokemon [Id do pokemon]
  *
  * @return Array $status [dados do pokemon]
  * @return Int   (0) retorna 0 em caso de pokemon sem status
  * @return Boolean false [caso algo de errado]
  *
  * @Exemplo $this->pro->getStatusRival($idPlayer);
  */
  function getStatusPokemon($idPokemon){
    $bd = new DataAccessMySQL('poke');
    $r = $bd->mountSelect('actualStatus','*')
      ->where([['idPokemon','=',$idPokemon]])
      ->execute();
    if( $r != false){
      //verifica se o array esta vazio
      if( empty( $r['list'] ) ){
        return 0;
      }return $r['list'][0];
    }
    //guarda o erro, para ser retornado
    $this->setLog(
     'Process.php',
     'getStatusPokemon',
     __LINE__,
     'select_table => status',
     $bd->getError()
    );
    return false;
  }//getStatusRival

  /** getApiRival
  * Pega os atributos básicos de interface do rival de acordo com idPlayer
  * @param Int idPlayer [Id do jogador]
  *
  * @return Array $rival [p.name,p.level,p.shiny]
  * @return Int   (0) retorna 0 em caso de jogador não tive rival
  * @return Boolean false [caso algo de errado]
  *
  * @Exemplo $this->pro->getApiRival($idPlayer);
  */
  function getRival($idPlayer){
    $bd = new DataAccessMySQL('poke');
    $r = $bd->mountSelect('getRival','name,acHP,maxHP,gender,shiny,level')
      ->where([['idPlayer','=',$idPlayer]])
      ->execute();
    if( $r != false){
      //verifica se o array esta vazio
      if( empty( $r['list'] ) ){
        return 0;
      }return ($r);
    }
    //guarda o erro, para ser retornado
    $this->setLog(
     'Process.php',
     'getStatusRival',
     __LINE__,
     'select_table => rival,pokemon',
     $bd->getError()
    );
    return false;
  }//getStatusRival

  /** getIdPokeRival
  * Pega o do idPokemon rival
  * @param Int idPlayer [Id do jogador]
  *
  * @return Int $idRival [id do rival]
  * @return Int   (0) retorna 0 em caso de jogador não tenha rival
  * @return Boolean false [caso algo de errado]
  *
  * @Exemplo $this->pro->getStatusRival($idPlayer);
  */
  function getIdPokeRival($idPlayer){
    $bd = new DataAccessMySQL('poke');
    $r = $bd->mountSelect('rival','idPokemon')
      ->where([['idPlayer','=',$idPlayer]])
      ->orderBy('id','DESC')
      ->execute();
    if( $r != false){
      //verifica se o array esta vazio
      if( empty( $r['list'] ) ){
        return 0;
      }return $r['list'][0]["idPokemon"];
    }
    //guarda o erro, para ser retornado
    $this->setLog(
     'Process.php',
     'getIdRival',
     __LINE__,
     'select_table => rival',
     $bd->getError()
    );
    return false;
  }//getStatusRival


   /** Pega os movimentos do Pokemon do jogador
   * @param Int $idPoke [Id do poke]
   *
   * @return Array [retorna os ataques e o tipo]
   * @return Boolean [false, caso aconteça erro]
   * $Process->getMoveInPokemon(10001);
   */
   function getMoveInPokemon($idPoke){
     $bd = new DataAccessMySQL('poke');
     $r  = $bd->mountSelect('tm t','ti.idTm,name,cat,pwr,acc,pp,type,t.idType')
       ->innerJoin('tmInPokemon ti','ti.idTm = t.idTm')
       ->innerJoin('type ty','ty.idType = t.idType')
       ->where([['idPokemon','=',$idPoke]])
       ->limit(4)
       // ->groupBy('','ASC')
       ->execute();
     if( $r != false){
       return ($r);
     }
     //guarda o erro, para ser retornado
     $this->setLog(
      'Process.php',
      'getMove',
      __LINE__,
      'select_table => getMove',
      $bd->getError()
     );
     return false;
   }//getMove

   /** Verifica se jogador esta em batalha(se tem um rival)
    * @param Int $idPlayer [Id do jogador]
    * @return Int 0 ? 1
    * @return Boolean false Error
    * $Process->verifyPlayerBattle();
    */
   function verifyPlayerBattle($idPlayer){
     $r  = $this->bd->mountSelect('rival',
       'idPokemon')
       ->where([['idPlayer','=',$idPlayer]])
       ->execute();
     //verifica se aconteceu erros
     if($r != false){
       if($r['count'] == 0){
         return 0;
       }else{
         return 1;
       }//elseif
     }//($r != false)
     //guarda o erro, para ser retornado
     $this->setLog(
       'select_rival',
       'verifyPlayerBattle',
        __LINE__,
       'error select => rival',
       $this->bd->getError()
     );
     return false;
   }//verifyPlayerBattle

  /** Gera os atk's do Pokemon
   * @param Int $idPoke [Id do poke no qual quer gerar atk's]
   * @param Int $idMold [id do pokemon mold, para saber as regras]
   * @param Int $lv [Nivel deste pokemon]
   *
   * @return Boolean true ? false
   *
   * $Process->gerateMove(233,4,10);
   */
  function gerateMove($idPoke,$idMold,$lv){
    // $bd = new DataAccessMySQL('poke');
    //pega todos os movimentos do pokemon mold menor ou igual ao nivel
		$r = $this->bd->mountSelect('moveLearn ml','ml.idTm,level,pp')
      ->innerJoin('tm t','t.idTm = ml.idTm')
			->where([
        ['idMold','=',$idMold],
        ['level','<=',$lv]
      ])->execute();
    //se o array estiver vazio, significa que não há ataques configurados
    if( empty( $r['list'] ) ){
      //guarda o erro, para ser retornado
      $this->setLog(
        'Process.php',
        'gerateMove',
         __LINE__,
        'Verify $move return empty',
        $this->bd->getError()
      );
      return false;
    }//if empty( $r['list'] ) )

    //verifica se aconteceu erro
		if($r == false){
      //guarda o erro, para ser retornado
      $this->setLog(
        'Process.php',
        'gerateMove',
        __LINE__,
        'select_table => moveLearn',
        $this->bd->getError()
      );
      return false;
		}//if ($r == false)

    //recebe a quantidade de movimentos
    $maxCount = $r['count'];
    //se tiver mais de 4 movimentos
    if( $maxCount > 4 ){
      $maxCount = 4;
    }//if( $maxCount > 4 )
    //reverte o array para pegar os ultimos ataques
    $r['list'] = array_reverse($r['list']);
    for($i=0;$i<$maxCount;$i++){
      $tm = [//prepara os dados para inserção
        'idTm'     =>$r['list'][$i]['idTm'],
        'idPokemon'=>$idPoke,
        'maxPP'   =>$r['list'][$i]['pp'],
        'actualPP'=>$r['list'][$i]['pp']
      ];//tenta inserir
      $resp = $this->bd->insert('tmInPokemon',$tm);
      //veridica erros
      if( $resp == false ){
          //guarda o erro, para ser retornado
          $this->setLog(
            'Process.php',
            'gerateMove',
            __LINE__,
            'insert_table => tmInPokemon',
            $this->bd->getError()
          );
          return false;
    		}//if( $resp == false )
      }//for
    return true;
  }//gerateMove


	/** geratePoke
  * Gera o array pokemon de acordo com o mold
  * @param Int $idMold [Id do mold do pokemon, Ex:Charmander id=4]
  * @param Int $lv [Nivel do pokemon que vai ser gerado]
  * @param Int $prob[probabilidade de shiny, de 1 a 1000]
  *
  * @return Array $poke [dados do pokemon gerado]
  * @return Boolean false [caso algo de errado, e nada sera alterado]
  */
  function geratePoke($idMold,$lv,$prob){
    //pega o poke de mold do BD, exemplo charmander é o número 004
    //!*getMold
    $p = $this->getMold($idMold);
    //verifica se ouve erro no getPoke, se sim, retornar o $log
    if($p == false){
      return $p;
    }
    //objeto de retorno, dados do pokemon
		$poke = ['name' => ( $p['name'] )];

    $r = $this->gerateStatus('hp',$p['hp'],$lv);
		$poke['hp']   = $r['status'];
    $poke['info'] = "{ \"hp\":{ \"iv\":{$r['iv']},\"ev\":{$r['ev']} }, ";

    $r = $this->gerateStatus('st',$p['atk'],$lv);
    $poke['atk']   = $r['status'];
    $poke['info'] .= "\"atk\":{ \"iv\":{$r['iv']},\"ev\":{$r['ev']} }, ";

    $r = $this->gerateStatus('st',$p['def'],$lv);
    $poke['def']   = $r['status'];
    $poke['info'] .= "\"def\":{ \"iv\":{$r['iv']},\"ev\":{$r['ev']} }, ";

    $r = $this->gerateStatus('st',$p['spAtk'],$lv);
    $poke['spAtk'] = $r['status'];
    $poke['info'] .= "\"spAtk\":{ \"iv\":{$r['iv']},\"ev\":{$r['ev']} }, ";

    $r = $this->gerateStatus('st',$p['spDef'],$lv);
    $poke['spDef'] = $r['status'];
    $poke['info'] .= "\"spDef\":{ \"iv\":{$r['iv']},\"ev\":{$r['ev']} }, ";

    $r = $this->gerateStatus('st',$p['speed'],$lv);
    $poke['speed'] = $r['status'];
    $poke['info'] .= "\"speed\":{ \"iv\":{$r['iv']},\"ev\":{$r['ev']} }   }";

    $poke['gender'] = $this->gerateGender($p['gender']);
    if($poke['gender'] == 0){
      $poke['gender'] = 'male';
    }else{
      $poke['gender'] = 'female';
    }
		$poke['shiny']	        = $this->gerateShiny($prob);
    $poke['level']          = $lv;
	  $poke['idEvolution']    = $p['idEvolution'];
    $poke['levelEvolution'] = $p['levelEvolution'];
    $poke['iv']             = $this->calcIV();
    $poke['idMold']         = $idMold;
    $poke['idType1']        = $p['idType1'];
    $poke['idType2']        = $p['idType2'];
    $poke['xp']             = 0;
    $poke['lr']             = $p['lr'];

    return $poke;
	}//geratePoke

  /** insertActualStatus
  * Insere status default no pokemon especifico, se o pokemon já tiver
  * actualStatus será resetado com valores default
  * @param Int $idPokemon [Id do poke que será inserido o status default]
  * @param Array $poke [Array completo do pokemon]
  *
  * @return Boolean true ? false
  */
  function insertActualStatus($idPoke,$poke){
    //prepara o array para o insert
    $statusPoke = [
      'hp'     => $poke['hp'],
			'atk'    => $poke['atk'],
			'def'    => $poke['def'],
			'spAtk'  => $poke['spAtk'],
			'spDef'  => $poke['spDef'],
			'speed'  => $poke['speed'],
      'stateName'   => 0,
      'stateDamage' => 0,
      'stateRound'  => 0,
      'idPokemon'   => $idPoke,
    ];
    //insere o pokemon na tabela Pokemon
    $r = $this->bd->insert('actualStatus',$statusPoke);
    //verifica se ouve erro na inserção
    if($r == false){
      $this->setLog('Process.php','insertActualStatus',
      __LINE__,'try insert_into => actualStatus',$this->bd->getError());
      return false;
    }
    return true;
  }//setStatus

  /** setPoke
  * Guarda um pokemon, configura ataques, status default no BD,
  * Ativa um ação relacional de acordo com a variavel $action:
  * @param Int $idPlayer [Id do jogador no qual sera relacionado o pokemon]
  * @param Array $poke [Array completo do pokemon]
  * @param Int $action [
  *    0 = relacionar o pokemon com as tabelas pokemonPlayer && bag
  *    1 = relacionar o pokemon com as tabelas pokemonPlayer && bank
  *    2 = relacionar o pokemon com a tabela rival
  *  ]
  *
  * Se o acontecer erro, retorna false
  * Se tudo não houve erros, retorna o identificador da ação.
  *
  * @return False ? @return Array $action ['action' => $action]
  */
  function setPoke($idPlayer,$poke,$action){
    if($action == 0){
      //!* VERIFICAR SE O JOGADOR POSSUI ALGUM POKEMON

      //Verifica se a bag esta cheia, se sim aciona ação 1, enviar para o banco
      $position = $this->bd->mountSelect('pokemonBag','idPosition')
        ->where([['idPlayer','=',$idPlayer]])
        ->execute();
      //position pode ir de 0 a 5
      if($position['count'] > 5 ){
        $action = 1;
      }//if($position['count'] > 5 )

      //verifica se existe pokemon igual na bag, se sim, guardar no banco
      $pokeBag = $this->bd->mountSelect('getListPokemonBag','name')
        ->where([['idPlayer','=',$idPlayer]])
        ->execute();

      for ($i=0; $i < $pokeBag['count']; $i++) {
        if($poke['name'] === $pokeBag['list'][$i]['name']){
          $action = 1;
          break;
        }
      }
    }//if($action == 0)

    //inicia a transação, caso aconteça erro, retornar false, e guardar o erro
    if( $this->bd->beginTransaction() == false ){
      //salva o erro especificamente
      $this->setLog('Process.php','setPoke',
      __LINE__,'try beginTransaction',$this->bd->getError());
      //retornar false
      return false;
    }//if( $this->bd->beginTransaction() == false )

    //insere o pokemon na tabela Pokemon
    $r = $this->bd->insert('pokemon',$poke);
    //verifica se ouve erro na inserção
    if($r == false){
      $this->setLog('Process.php','setPoke',
      __LINE__,'try insert_into => pokemon',$this->bd->getError());
      return false;
    }//if $r == false)

    //insere os movimentos no pokemon
    //!*
    $move = $this->gerateMove( $r['id'],$poke['idMold'],$poke['level'] );
    //verifica se ouve erro em gerateMove
    if($move == false){
      return false;
    }//if($move == false))

    //insere os status do pokemon
    $status = $this->insertActualStatus($r['id'],$poke);
    //verifica se ouve erro em gerateStatus
    if($status == false){
      return false;
    }//if($status == false)

    //verifica qual o tipo de ação relacional
    if($action == 0 || $action == 1){
      $pokemonPlayer = [
        'idPokemon'=>$r['id'],
        'dead'  => 0,
        'active'=> 0,
        'nickname'=> ($poke['name']),
        'idPlayer'=> $idPlayer,
        'idItem'  => null,
      ];
      //guarda o pokemon do jogador na tabela pokemonPlayer
      $r = $this->bd->insert('pokemonPlayer',$pokemonPlayer);
      //verifica se houve erro
      if($r == false){
        $this->setLog('Process.php','setPoke_action = 0 || 1',
        __LINE__,'try insert_into => pokemonPlayer',$this->bd->getError());
        return false;
      }//if($r == false)
      //guardar na bag
      if($action == 0){
        //Verifica se tem pokemon na bag, se tiver Position deve receber +1
        $position = $this->bd->mountSelect('pokemonBag','idPosition')
          ->where([['idPlayer','=',$idPlayer]])
          ->orderBy('idPosition','DESC')
          ->limit(1)
          ->execute();
        //Adiciona +1 na posição
        $idPosition = (intval($position['list'][0]['idPosition'])+(1));

        $pokemonBag = [
          'idPosition' => $idPosition,
          'idPlayer'   => $idPlayer,
          'idPokemonPlayer' => $r['id'],
        ];
        //guarda os dados do pokemon na tabela pokemonBag
        $r = $this->bd->insert('pokemonBag',$pokemonBag);
        //verifica se houve erro
        if($r == false){
          $this->setLog('Process.php','setPoke_action = 0',
          __LINE__,'try insert_into => pokemonBag',$this->bd->getError());
          return false;
        }//if($r == false)
      }//if($action == 0)

      //guardar no banco
      else if($action == 1){
        $bank = [
          'idPlayer'        => $idPlayer,
          'idPokemonPlayer' => $r['id'],
        ];
        //guarda o pokemon
        $r = $this->bd->insert('bank',$bank);
        //verifica se houve erro
        if($r == false){
          $this->setLog('Process.php','setPoke_action = 1',
          __LINE__,'try insert_into => bank',$this->bd->getError());
          return false;
        }
      }//if($action == 1)

    }//if $action == 0 || $action == 1

    //guardar rival
    else if($action == 2){
      $rival = [
        'idPlayer'  => $idPlayer,
        'idPokemon' => $r['id']
      ];
      //guarda no rival
      $r = $this->bd->insert('rival',$rival);
      //verifica se houve erro
      if($r == false){
        $this->setLog('Process.php','setPoke',
        __LINE__,'try insert_into => rival',$this->bd->getError());
        return false;
      }
    }//$action == 2
    //tenta guardar os dados processados acima
    if( $this->bd->commit() == false){
      $this->setLog('Process.php','setPoke',
      __LINE__,'try commit',$this->bd->getError());
      return false;
    }//if commit
    return ['action' => $action];
  }//setPoke

  /** retorna o mold pokemon de acordo com os id
  * @param Int $id [id do mold pokemon no qual deseja obter]
  *
  * @return Array $poke [dados da tabela mold]
  * @return Boolean false [caso de erro]
  */
  function getMold($id){
    $bd = new DataAccessMySQL('poke');
    $r = $bd->mountSelect('mold','*')
      ->where([['idMold', '=',$id]])
      ->execute();
    if( $r != false){
      return $this->getResult($r);
    }
    //guarda o erro, para ser retornado
    $this->setLog(
      'Process.php',
      'getMold',
      __LINE__,
      'select_table => mold',
      $this->bd->getError()
    );
    return false;
  }//getpoke

  /** Pega um pokemon do BD de acordo com $id
  * @param Int $id [id do pokemon do qual deseja obter]
  *
  * @return Array $poke [dados da tabela pokemon]
  * @return Boolean false [caso de erro]
  */
	function getPoke($id){
		$bd = new DataAccessMySQL('poke');
		$r = $bd->mountSelect('pokemon','*')
			->where([['idPokemon', '=',$id]])
			->execute();
		if( $r != false){
		  return $this->getResult($r);
		}
    //guarda o erro, para ser retornado
    $this->setLog(
      'Process.php',
      'getPoke',
      __LINE__,
      'select_table => pokemon',
      $this->bd->getError()
    );
    return false;
  }//getpoke

  //pega o log de erros
  public function getLog(){
    return $this->log;
  }

  //salva o erro especificamente
  function setLog($title,$function,$line,$objective,$msg){

    $texto = json_encode([
      'Document'  => 'Process.php',
      'line'      => '['.$line.']',
      'title'     => $title,
      'function'  => $function,
      'objective' => $objective,
      'msg_error' => $msg,
      'hours'     => date("H:i:s"),
      'date'      => date("d-m-Y")
    ]);
    // echo getcwd();die;
    //Variável arquivo armazena o nome e extensão do arquivo.
    $arquivo = getcwd().'/v0.2/extensions/Game/log/Process('.$title.')-'.$line.'-'.date("h:i:s_d-m-Y").'.json';
    // $arquivo = '/extensions/Game/log/error_'.date("d-m-Y").'.json';
    //Variável $fp armazena a conexão com o arquivo e o tipo de ação.
    $fp = fopen($arquivo, "a");
    //Escreve no arquivo aberto.
    fwrite($fp, $texto);
    //Fecha o arquivo.
    fclose($fp);
    Response::setStatusCode(500);
  }


  /*recebe um numero de 1 a 1000, e retorna o serteio
    se for 0 não é shiny*/

  /** gerateShiny
  * randomiza a probabilidade de ser shiny
  * @param Int $prob[probabilidade de ser shiny]
  *
  * @return Int [1 shiny, 0 normal]
  */
  function gerateShiny($prob){
    if(rand(1,1000) <= $prob){
      return 1;
    } return 0;
  }//gerateShiny

  /** gerateGender
  * Gera o sexo do pokemon de acordom com a probabilidade de ser macho
  * @param Int $g[probabilidade de ser macho]
  *
  * @return Int [0 macho, 0 fêmea]
  */
  function gerateGender($g){
    $r = rand(1,100);
		if($r <= $g){
			return 0;
		}return 1;
	}//gerateGender

  //calcula a porcentagem de IV total
	function calcIV(){
		return intval( ( 100/186 )*($this->IV) );
	}//calcIV

  /** Gera um atributo status do pokemon
  * @param String $st [nome do status que deve gerar]
  * @param Int    $base [valor do status base]
  * @param Int    $lv[]
  *
  * @return Int [nivel do pokemon]
  */
  function gerateStatus($st,$base,$lv){
    $iv = rand(0,31);
    $ev = rand(0,252);
    $this->IV += $iv;
    //começando o calculo
    $b  = (2*$base);
    $b  = ($b+$iv);
    $b2 = ($ev/4);
    $b  = ($b+$b2);
    $b  = ($b*$lv);
    $b  = ($b/100);
    //se for calculo de HP
    if($st == 'hp' ){
      $b2 = ($lv+10);
      $b  = ($b+$b2);
      return ['status' => intval($b),'iv'=>$iv,'ev'=>$ev];
      // return intval( ( ( (2*$base +$iv +($ev/4) )*$lv)/100 ) + $lv + 10 );
    }
    // se for outro calculo
    $b = ($b+5);
    return ['status' => intval($b),'iv'=>$iv,'ev'=>$ev];
    // return intval( ( ( (2*$base+$iv+($ev/4) )*$lv)/100 ) + 5 );
  }//fim gerateStatus

  /** Gera um atributo status do pokemon
  * @param String $st [nome do status que deve gerar]
  * @param Int    $base [valor do status base]
  * @param Int    $lv[nivel do pokemon]
  *
  * @return Int [nivel do pokemon]
  */
  function gerateStatusStatic($st,$base,$lv,$iv,$ev){
    $this->IV += $iv;
    //começando o calculo
    $b  = (2*$base);
    $b  = ($b+$iv);
    $b2 = ($ev/4);
    $b  = ($b+$b2);
    $b  = ($b*$lv);
    $b  = ($b/100);
    //se for calculo de HP
    if($st == 'hp' ){
      $b2 = ($lv+10);
      $b  = ($b+$b2);
      return intval($b);
      // return intval( ( ( (2*$base +$iv +($ev/4) )*$lv)/100 ) + $lv + 10 );
    }
    // se for outro calculo
    $b  = ($b+5);
    return intval($b);
    // return intval( ( ( (2*$base+$iv+($ev/4) )*$lv)/100 ) + 5 );
  }//fim gerateStatus


  //formata o resultado em array simples
  function getResult($r){
    if(!empty($r['list'])){
      return $r['list'][0];
    }
    return $r['list'];
  }//calcIV

################### EFETIVIDADES #########################

  //verifica a efetividade e devolve o valor a ser multiplicado, se for 0 é imune
  function typeEffective($type_a,$type_b){
    //echo "Verificando efetividade...<br>";
    switch ($type_a) {
      case 1:
        return $this->type_normal($type_b);
        break;
      case 2:
        return $this->type_fire($type_b);
        break;
      case 3:
        return $this->type_fighting($type_b);
        break;
      case 4:
        return $this->type_water($type_b);
        break;
      case 5:
        return $this->type_flying($type_b);
        break;
      case 6:
        return $this->type_grass($type_b);
        break;
      case 7:
        return $this->type_poison($type_b);
        break;
      case 8:
        return $this->type_electric($type_b);
        break;
      case 9:
        return $this->type_ground($type_b);
        break;
      case 10:
        return $this->type_psychic($type_b);
        break;
      case 11:
        return $this->type_rock($type_b);
        break;
      case 12:
        return $this->type_ice($type_b);
        break;
      case 13:
        return $this->type_bug($type_b);
        break;
      case 14:
        return $this->type_dragon($type_b);
        break;
      case 15:
        return $this->type_ghost($type_b);
        break;
      case 16:
        return $this->type_dark($type_b);
        break;
      case 17:
        return $this->type_steel($type_b);
        break;
      case 18:
        return $this->type_fairy($type_b);
        break;
      default:
        break;
    }
  }

  function type_fairy($type){
    if($type==16 || $type==14 || $type==3) {
      return 2;
    }else if($type==2 || $type==7 || $type==17){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_steel($type){
    if($type==18 || $type==12 || $type==11) {
      return 2;
    }else if($type==8 || $type==2 || $type==17 || $type==4){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_dark($type){
    if($type==15 || $type==10) {
      return 2;
    }else if($type==16 || $type==18 || $type==3){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_ghost($type){
    if($type==15 || $type==10) {
      return 2;
    }else if($type==16){
      return 0.5;
    }else if($type==1){
      return 0;
    }else{
      return 1;
    }
  }

  function type_dragon($type){
    if($type==14) {
      return 2;
    }else if($type==17){
      return 0.5;
    }else if($type==18){
      return 0;
    }else{
      return 1;
    }
  }

  function type_bug($type){
    if($type==16 || $type==6 || $type==10) {
      return 2;
    }else if($type==18 || $type==3 || $type==2 || $type==5
    || $type15 || $type==7 || $type==17){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_ice($type){
    if($type==14 || $type==5 || $type==6 || $type==9) {
      return 2;
    }else if($type==2 || $type==12 || $type==17 || $type==4){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_rock($type){
    if($type==13 || $type==2 || $type==5 || $type==12) {
      return 2;
    }else if($type==3 || $type==9 || $type==17){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_psychic($type){
    if($type==3 || $type==7) {
      return 2;
    }else if($type==10 || $type==17){
      return 0.5;
    }else if($type==16){
      return 0;
    }else{
      return 1;
    }
  }

  function type_ground($type){
    if($type==8 || $type==2 || $type==7 || $type==11
    || $type==17) {
      return 2;
    }else if($type==13 || $type==6){
      return 0.5;
    }else if($type==5){
      return 0;
    }else{
      return 1;
    }
  }

  function type_electric($type){
    if($type==5 || $type==4) {
      return 2;
    }else if($type==14 || $type==8 || $type==6){
      return 0.5;
    }else if($type==9){
      return 0;
    }else{
      return 1;
    }
  }

  function type_poison($type){
    if($type==18 || $type==6) {
      return 2;
    }else if($type==7 || $type==9 || $type==11 || $type==15){
      return 0.5;
    }else if($type==17){
      return 0;
    }else{
      return 1;
    }
  }

  function type_grass($type){
    if($type==9 || $type==11 || $type==4) {
      return 2;
    }else if($type==13 || $type==14 || $type==2 || $type==5
    || $type==6 || $type==7 || $type==17){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_flying($type){
    if($type==13 || $type==3 || $type==6) {
      return 2;
    }else if($type==8 || $type==11 || $type==17){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_water($type){
    if($type==2 || $type==9 || $type==11) {
      return 2;
    }else if($type==14 || $type==6 || $type==4){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_normal($type){
    if($type==15) {
      return 0;
    }else if($type==17 || $type==11){
      return 0.5;
    }else{
      return 1;
    }
  }

  function type_fire($type){
    if($type==13 || $type==6 || $type==12 || $type==17) { //echo "type_fire = 2<br>";
      return 2;
    }else if($type==14 || $type==2 || $type==11 || $type==4){ //echo "type_fire = 0.5<br>";
      return 0.5;
    }else{ //echo "type_fire = 1<br>";
      return 1;
    }
  }

  function type_fighting($type){
    if($type==16 || $type==12 || $type==1 || $type==11
    || $type==17) {
      return 2;
    }else if($type==13 || $type==18 || $type==5 || $type==7
    || $type==10){
      return 0.5;
    }else if($type==15){
      return 0;
    }else{
      return 1;
    }
  }

}//Process
?>
