<?php namespace Api;
 /**
  *
  */
 class Battle{
   //veriáveis de batalha
   function __construct($idPlayer){
     $this->pro = new Process();
     $this->update = new Update();
     $this->idPlayer = $idPlayer;
     //pokemon atacante
     $this->pokeAtk   = '';
     //pokemon defensor
     $this->pokeDef   = '';
     //status dos pokemons
     $this->statusAtk = '';
     $this->statusDef = '';
     //array de tudo que aconteceu na batalha
     $this->log['process'] = true;
     $this->log['battle']  = true;
     $this->log['error']   = '';
     $this->case      = 0;

     //definir quem é o atacante e quem é o defensor
     //tenta pegar o pokemon da primeira posição na bolsa de pokemon
     // se retornar 0, o jogador não possui pokemons vivos
     $idPokePlayer = $this->pro->getIdPokemonBagByAlive($idPlayer);
     if($idPokePlayer == 0){
       $this->log['error'] = 'idPokePlayer';
       $this->log['process'] = false;
     }
     //tenta pegar o pokemon rival
     $idPokeRival = $this->pro->getIdPokeRival($idPlayer);
     if($idPokeRival == 0 && $this->log['process']){
       $this->log['error'] = 'idPokeRival';
       $this->log['process'] = false;
     }
     //verifica se não houve erro acima
     if($this->log['process']){
       //pegando os dados dos pokemons
       $this->pokePlayer = $this->pro->getPoke($idPokePlayer);
       $this->pokeRival  = $this->pro->getPoke($idPokeRival);
       //pegando os atuais status
       $this->statusPlayer = $this->pro->getStatusPokemon($idPokePlayer);
       $this->statusRival  = $this->pro->getStatusPokemon($idPokeRival);

       $this->next = 1;
      }//if($this->log['process'] == true){
    }//__construct
       /*
       //iniciando transação com banco para salvar
       $this->bd = new DataAccessMySQL('poke');
       //inicia a transação, caso aconteça erro, retornar false, e guardar o erro
       if( $bd->beginTransaction() == false ){
         //salva o erro especificamente
         $this->setLog('Battle.php','__construct()',
         __LINE__,'try beginTransaction',$this->bd->getError());
         //!* verificar se é possivel contrutor retornar false
         $this->log['error'] = 'API_INTERNAL_ERROR_BT_BD';
         $this->log['process'] = false;
       }//if( $bd->beginTransaction() == false )
     }//fim if log
     */

   /**
    * Função que define a batalha PVE.
    * verifica quem começa de acordo com speed
    * @param Int $numAtk [identificador do ataque(max 4)]
    * @return Array $log Retorna o log do que aconteceu na batalha
    */
   function roundPVE($numAtk){
     if(!$this->log['process']){
       return $this->log;
     }

     //verifica se os ataques são iguais, se sim sortear quem começa
     if($this->statusPlayer['speed'] == $this->statusRival['speed']){
       $case = rand(1,2);
       if($case == 1){
         $log['init']   = 'Player';
         //inicia a batalha com o jogador começando em caso de caso = 1
         $log['FIRST']  = $this->roundPlayer($numAtk);
         //veriicase pokemon rival morreu, se sim retornar o log
         if($log['battle'] == false){
           return $log;
         }//if
         $log['SECOND'] = $this->roundRival();
       }else{
         $log['init']   = 'Rival';
         $log['FIRST']  = $this->roundRival();
         // if($log['battle'] == 'player_dead' || $log['battle'] == 'switch'){
         //   return $log;
         // }//if
         $log['SECOND'] = $this->roundPlayer($numAtk);
       }//else
     }//if($this->statusPlayer['speed'] == $this->statusRival['speed'])
     //=================== fim cado speed empate ========================
     //verifica se o speed do jogador é maior
     else if($this->statusPlayer['speed'] > $this->statusRival['speed']){
       $log['init']   = 'Player';
       $log['FIRST']  = $this->roundPlayer($numAtk);
       if($log['FIRST']['battle'] === false){
         return $log;
       }
       $log['SECOND'] = $this->roundRival();
     }//fim verificação se jogador começa
     //verifica se speed do inimigo é maior
     else if($this->statusRival['speed'] > $this->statusPlayer['speed'] ){
       $log['init']   = 'Rival';
       $log['FIRST']  = $this->roundRival();
       if(($log['FIRST']['battle'] === 'player_dead') || ($log['FIRST']['battle'] === 'switch')){
         return $log;
       }//if
       $log['SECOND'] = $this->roundPlayer($numAtk);
     }//else if
     //nehuma das condições foram atendidas, algo deu errado reportar o erro
     else{
       $this->setLog('Error_verify_start_battle','salveBattle',
       __LINE__,'error in verify start battle decison ',
       'else roundPVE start battle');
       //retornar false
       return false;
     }
     //updates
     //!* voltar ao normal status temporarios(atk,spAtk,def,spDef,speed)
     //!* fazer update dos status permanentes:
     //    (hp,stateName,stateDamage,stateRound)
     //
     //
     //   /* $this->pokeRival  = $this->pro->getPoke($idPokeRival);
     //   //pegando os atuais status
     //   $this->statusPlayer
     //   */
     //   $xp = $this->pro->processXP($idPoke,$variablesXP);
     //   if ($xp != false){
     //     if($xp['levelUp']){
     //       $this->statusPlayer['atk']    => $this->pokePlayer['atk'];
     //       $this->statusPlayer['def']    => $this->pokePlayer['def'];
     //       $this->statusPlayer['spAtk']  => $this->pokePlayer['spAtk'];
     //       $this->statusPlayer['spDef']  => $this->pokePlayer['spDef'];
     //       $this->statusPlayer['speed']  => $this->pokePlayer['speed'];
     //     }//if($xp['levelUp'])
     //
     //   }//if ($xp != false)
     //
     return $log;
   }

   /**
   * processa a rodada do JOGADOR
   * @param Int @numAtk[numero do ataque, max 4]
   * @return Array $log[acontecimentos da rodada]
   */
   function roundPlayer($numAtk){
     //configura array de inicialização
     $this->pokeAtk   = $this->pokePlayer;
     $this->pokeDef   = $this->pokeRival;
     $this->statusAtk = $this->statusPlayer;
     $this->statusDef = $this->statusRival;
     //pega o atk do pokemon atacante
     $move = $this->pro->getMoveInPokemon($this->pokeAtk['idPokemon']);
     //em caso de array vazio, error
     if(empty( $move['list'] )){
       $this->setLog('Empty_array','roundPlayer',
       __LINE__,'variable move[list] is empty',
       'error:pokémon without attak');
       //retornar false
       return false;
     }
     //se quantidade de ataque for maior que $move['count']
     if($numAtk > $move['count']){
       $numAtk = rand(0,$move['count']);
     }
     // caso a posição do ataque($numAtk) não exista
     if(!isset($move['list'][$numAtk])){
       $numAtk = ( rand( 0,$move['count']-(1) ) );
     }
     //pega o ataque solicitado de 0 a 3
     $move = $move['list'][$numAtk];
     // <salvar>
     //salvando no retorno o nome do movimento
     $info['move_name'] = $move['name'];
     //Caso seja habilidades de dano
     if($move['cat'] == 'phy' || $move['cat'] == 'spe'){
       //salvar info log
       $info['atk'] = true;
       //!* verificar se o ataque tem algum effeito, e aplicar
       $info['damage'] = $this->attack($move);
       //verifica se acertou
       if($info['damage'] === 'fail'){
         $log['log'][0] = $this->pokeAtk['name'].
          " errou o movimento {$move['name']}!";
       }else{
         $log['log'][0] = $this->pokeAtk['name'].
            " atacou com movimento {$move['name']}";
          $eff = $this->effectAtks($move);
          if($eff == false){
            $info['effect'] = false;
          }else{
            $info['effect'] = true;
            $log['log'][1] = $eff;
          }//else
       }//else
     }//fim $move['cat'] == 'phy' || $move['cat'] == 'spe'

     //se for movimendo de status
     else if($move['cat'] == 'sta'){
       $info['atk'] = false;
       if( !$this->verifyAcc($move) ){
         $log['log'][0] = $this->pokeAtk['name'].
          " errou a Habilidade {$move['name']}!";
       }else{
         $log['log'][0] = $this->pokeAtk['name'].
          " usou Habilidade ".$move['name'];
         $log['log'][1] = $this->effectStatus($move);
       }
     }//else if($move['cat'] == 'sta')

     //=========== fim da fase de ataque ============

     //salva no log
     $log['info'] = $info;
     $log['battle'] = true;

     //=========== fase de verificação de ganho XP ======
     //verifica se o pokemon defensor morreu, se sim processar XP e salvar
     if( $this->statusDef['hp'] < 1 ){
       $log['rival'] = "dead";
       /*!* rival morto
       - remover do banco
       - Validar quest
       */
       $log['log'][1] = $this->pokeDef['name'].' foi derrotado!';
       $log['battle'] = false;
       //processo de experiência
       $b = $this->pro->getMold($this->pokeDef['idMold']);
       //Acrescenta XP no pokemon do jogador
       $this->pokeAtk['xp'] = $this->pro->addXP($this->pokeAtk,[
         'a'=>1,'b'=>$b['xp'],'e'=>1,'f'=>1,
         'l'=>$this->pokeDef['level'],'s'=>2,'t'=>1
       ]);
       //-----> !* Verificação se o pokemon deve evoluir, subir de nivel ou nada

       //verifica se pokemon sobe de nivel e evolui
       if($this->pro->verifyLevelUp($this->pokePlayer) == 2){
         $this->pokemonPlayer = $this->pro->setStatusEvolution($this->pokeAtk);
         // !* evoluiu então deve resetar e salvar os novos status
         //salvando status da tabela Pokemon
         $up = $this->update->updateStatusEvolution($this->pokeAtk);
         if($up == false){
           return false;
         }
         $log['pokeXP'] = 'evolution';
       }//if
       //verifica se pokemon sobe de nivel
       //!* salvar poke
       elseif($this->pro->verifyLevelUp($this->pokeAtk) == 1){
         $this->pokemonPlayer = $this->pro->setStatus($this->pokeAtk);
         //!* evoluiu então deve resetar e salvar os novos status
         $up = $this->update->updateStatusLevelUp($this->pokeAtk);//salvando status de update
         if($up == false){
           return false;
         }
         $log['pokeXP'] = 'levelUp';
       }
       //apenas ganhou XP
       //!* salvar apenas status XP
       else{
         $up = $this->update->updatePokeXP($this->pokeAtk);
         if($up == false){
           return false;
         }
         $log['pokeXP'] = 'gain';
       }
       //!*salvar pokemon player, pois a batalha terminou
       /*verificação do que vai ser salvo na tabela pokemon, de acordo com
         a variável $updatePoke{
         0 = salvar apenas atributo XP
         1 = salvar 6 status base (hp,atk,def,spAtk,spDef,speed)
       }
       */

     }//if( $this->statusDef['hp'] < 1 )

     //############ fase de salvar dados ###########
     # jogador -> $this->statusAtk;
     # rival   -> $this->statusDef;




     //!* rival esta morto, verificar gatilhos de missão e deletar do banco
     //salvar status do rival

     /* !* verificar se no decorrer dessa batalha
           aconteceu algo com o poke atacante, se sim salvar status
           que foi alterado
     */
     if(isset($log['salveStatusSelf'])){
       //$log['salveStatusSelf']['status'] guarda o nome do status afetado
     }
     return $log;
   }//roundPlayer

   function roundRival(){
     //configura os array de inicialização
     $this->pokeAtk   = $this->pokeRival ;
     $this->pokeDef   = $this->pokePlayer;
     $this->statusAtk = $this->statusRival;
     $this->statusDef = $this->statusPlayer;
     //pega o atk do pokemon atacante
     $move = $this->pro->getMoveInPokemon($this->pokeAtk['idPokemon']);
     //em caso de array vazio
     if(empty( $move['list'] )){
       //!* reportar erro!!!
       // ACRSCENTAR GRAVIDADE MAXIMA
       return ['Poke sem ataque!!'];
     }
     //sorteia um ataque
     $numAtk = rand(0,$move['count']);

     // caso a posição do ataque($numAtk) não exista
     if(!isset($move['list'][$numAtk])){
       $numAtk = ( rand( 0,$move['count']-(1) ) );
     }

     $numAtk = 1;
     //pega o ataque solicitado de 0 a 3
     $move = $move['list'][$numAtk];
     //salvando no retorno o nome do movimento
     $info['move_name'] = $move['name'];
     //Caso seja habilidades de dano
     if($move['cat'] == 'phy' || $move['cat'] == 'spe'){
       //salvar info para o log
       $info['atk'] = true;
       //verifica se o ataque tem algum effeito
       $info['damage'] = $this->attack($move);
       //verifica se acertou
       if($info['damage'] === 'fail'){
         $log['log'][0] = $this->pokeAtk['name'].
          " errou o movimento {$move['name']}!";
       }else{
         $log['log'][0] = $this->pokeAtk['name'].
            " atacou com movimento ".$move['name'];
          $eff = $this->effectAtks($move);
          if($eff == false){
            $info['effect'] = false;
          }else{
            $info['effect'] = true;
            $log['log'][1] = $eff;
          }//else
      }//else
     }else if($move['cat'] == 'sta'){
       $info['atk'] = false;
       if( !$this->verifyAcc($move) ){
         $log['log'][0] = $this->pokeAtk['name'].
          " errou a Habilidade {$move['name']}!";
       }else{
         $log['log'][0] = $this->pokeAtk['name'].
          " usou Habilidade ".$move['name'];
         $log['log'][1] = $this->effectStatus($move);
       }
     }//else if($move['cat'] == 'sta')
     $log['info'] = $info;
     $log['battle'] = true;
     //verifica se o pokemon defensor morreu
     if( $this->statusDef['hp'] < 1 ){
       //salvar no log
       $log['log'][1] = $this->pokeDef['name'].' foi derrotado!';
       //verifica todos pokemons da bolsa do jogador estão mortos
       if( $this->pro->getIdPokemonBagByAlive($this->idPlayer) == 0 ){
         //informa no lçg
         $log['battle'] = 'player_dead';
       }
       //ainda tem pokemon para batalhar, informar no log
       else{
         $log['battle'] = 'switch';
       }
     }//if( $this->statusDef['hp'] < 1 )
     //guardando alterações da batalha para salvar

     $this->statusPlayer = $this->statusDef;
     $this->statusRival  = $this->statusAtk;
     return $log;
   }//roundRival

  /**
   * salva os dados da batalha
   * @return boolean
   */
   function __salveBattle(){
     /* Salvar
     $this->pokePlayer;
     $this->pokeRival;
     $this->statusPlayer;
     $this->statusRival;
     */
     //!* voltar ao normal status temporarios(atk,spAtk,def,spDef,speed)
     //!* fazer update dos status permanentes:
     //    (hp,stateName,stateDamage,stateRound)

     $bd = new DataAccessMySQL('poke');
     //inicia a transação, caso aconteça erro, retornar false, e guardar o erro
     if( $bd->beginTransaction() == false ){
       //salva o erro especificamente
       $this->setLog('beginTransaction','salveBattle',
       __LINE__,'try beginTransaction',$this->bd->getError());
       //retornar false
       return false;
     }//if( $this->bd->beginTransaction() == false )

     //guardando pokemon jogador
     $r = $bd->update('pokemon',$this->pokePlayer,
      ['idPokemon'=>$this->pokePlayer['idPokemon']]);

     //verifica se houve erro
     if(!$r){
       $this->setLog(
         'update_table',
         'updatePoke',
         __LINE__,
         'update_table => pokemon',
         $this->bd->getError()
       );
       return false;
     }//if(!$r)

     //guardando pokemon rival
     $r = $bd->update('pokemon',$this->pokeRival,
      ['idPokemon'=>$this->pokeRival['idPokemon']]);

     //verifica se houve erro
     if(!$r){
       $this->setLog(
         'update_table',
         'updatePoke',
         __LINE__,
         'update_table => pokemon',
         $this->bd->getError()
       );
       return false;
     }//if(!$r)

     //guardando status jogador
     $r = $bd->update('actualStatus',$this->statusPlayer,
      ['idPokemon'=>$this->statusPlayer['idPokemon']]);

     //verifica se houve erro
     if(!$r){
       $this->setLog(
         'update_table',
         'salveBattle',
         __LINE__,
         'update_table => actualStatus',
         $this->bd->getError()
       );
       return false;
     }//if(!$r)

     //guardando status rival
     $r = $bd->update('actualStatus',$this->statusRival,
      ['idPokemon'=>$this->statusRival['idPokemon']]);

     //verifica se houve erro
     if(!$r){
       $this->setLog(
         'update_table',
         'salveBattle',
         __LINE__,
         'update_table => actualStatus',
         $this->bd->getError()
       );
       return false;
     }//if(!$r)

     //tenta guardar os dados processados acima
     if( $bd->commit() == false){
       $this->setLog('commit','salveBattle',
       __LINE__,'try commit',$bd->getError());
       return false;
     }//if commit
     return true;
   }//salveBattle

   function __roundPVE($numAtk){
     //verifica se o jogador tem pokemon vivo para batalhar
     if($this->case == 10){
       return ['init'=>0];
     }
     //se caso for 0, o sistema verificará quem começa
     if($this->case == 0){
       //empate sortear de 1 a 2
       if($this->statusPlayer['speed'] == $this->statusRival['speed']){
         $case = rand(1,2);
       }
       //verificar quem é o atacante(1 jogador começa)
       else if($this->statusPlayer['speed'] > $this->statusRival['speed']){
         $this->log['init'] = 'Player';
         $case = 1;
       }else{
         $this->log['init'] = 'Rival';
         $case = 2;
       }
       //se caso for 1, rival começa
       if($this->case == 1){
         $this->case == 2;
       }
       //????
       else{
         $this->case == 1;
       }

     }//if($this->case == 0)
     else{
       $case = $this->case;
     }//else

     switch ($case) {
       case 1: //o jogador começa
        $this->pokeAtk   = $this->pokePlayer;
        $this->pokeDef   = $this->pokeRival;
        $this->statusAtk = $this->statusPlayer;
        $this->statusDef = $this->statusRival;
        $this->case = 2;
       break;
       default://o rival começa
        $this->pokeAtk   = $this->pokeRival ;
        $this->pokeDef   = $this->pokePlayer;
        $this->statusAtk = $this->statusRival;
        $this->statusDef = $this->statusPlayer;
        $this->case = 1;
        $numAtk = rand(0,3);
       break;
     }
     //pega o atk do pokemon atacante
     $move = $this->pro->getMoveInPokemon($this->pokeAtk['idPokemon']);
     //em caso de array vazio
     if(empty( $move['list'] )){
       //!* reportar erro!!!
       // ACRSCENTAR GRAVIDADE MAXIMA
       return ['Poke sem ataque!!'];
     }

     //se parametro for maior que 3
     // if($numAtk > 3){
     //   $numAtk = 3;
     // }

     //se quantidade de ataque for maior que $move['count']
     if($numAtk > $move['count']){
       $numAtk = rand(0,$move['count']);
     }

     // caso a posição do ataque($numAtk) não exista
     if(!isset($move['list'][$numAtk])){
       $numAtk = ( rand( 0,$move['count']-(1) ) );
     }

     // !* REMOVER
     if($this->log['init'] = 'Player'){
      $numAtk = 1;
     }

     //pega o ataque solicitado de 0 a 3
     $move = $move['list'][$numAtk];
     //salvando no retorno o nome do movimento
     $info['move_name'] = $move['name'];
     //Caso seja habilidades de dano
     if($move['cat'] == 'phy' || $move['cat'] == 'spe'){
       //salvar e info log
       $info['atk'] = true;
       //verifica se o ataque tem algum effeito
       $info['damage'] = $this->attack($move);
       //verifica se acertou
       if($info['damage'] == 'fail'){
         $log['log'][0] = $this->pokeAtk['name'].
          " errou o movimento {$move['name']}!";
       }else{
         $log['log'][0] = $this->pokeAtk['name'].
            " atacou com movimento ".$move['name'];
          $eff = $this->effectAtks($move);
          if($eff == false){
            $info['effect'] = false;
          }else{
            $info['effect'] = true;
            $log['log'][1] = $eff;
          }//else
      }//else
       //$log['action_attack']['name'] = $move['name'];
     }else if($move['cat'] == 'sta'){
       $info['atk'] = false;
       if( !$this->verifyAcc($move['acc']) ){
         $log['log'][0] = $this->pokeAtk['name'].
          " errou a Habilidade {$move['name']} !";
       }else{
         $log['log'][0] = $this->pokeAtk['name'].
          " usou Habilidade ".$move['name'];
         $log['log'][1] = $this->effectStatus($move);
       }
     }//else if($move['cat'] == 'sta')

     //Final da vez do segundo pokemon
     if($this->next == 2){
       $this->log['SECOND']['name'] = $this->pokeAtk['name'];
       $this->log['SECOND'] = $log;
       $this->log['SECOND']['info'] = $info;
       // verifica se o poke defensor esta vivo
       if( $this->statusDef['hp'] > 0 ){
         $this->next++;
         $this->roundPVE(0);
       }else{
         $this->log['SECOND']['log'][1] = $this->pokeDef['name'].' foi derrotado!';
       }
       // return;
     }

     // Final da vez do primeiro pokemon
     if($this->next < 2){
       $this->log['FIRST']['name'] = $this->pokeAtk['name'];
       $this->log['FIRST'] = $log;
       $this->log['FIRST']['info'] = $info;
       // verifica se o poke defensor esta vivo
       if( $this->statusDef['hp'] > 0 ){
         $this->next++;
         $this->roundPVE(0);
       }else{
         $this->log['FIRST']['log'][1] = $this->pokeDef['name'].' foi derrotado!';
       }
     }

     //caso o jogador seja o pokeAtk
     if($this->case == 2){
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
       //verifica se o poke Rival morreu
       if($this->statusDef['hp'] < 1){
         $this->log['battle'] = false;
         // $this->log['FIRST']['log'][1] = $this->pokeDef['name'].' foi derrotado!';
         //fazer o ganho de XP
         $b = $this->pro->getMold($this->pokeDef['idMold']);
         //Acrescenta(soma) XP no pokemon do jogador
         $this->pokeAtk['xp'] = $this->pro->addXP($this->pokeAtk,[
           'a'=>1,'b'=>$b['xp'],'e'=>1,'f'=>1,
           'l'=>$this->pokeDef['level'],'s'=>2,'t'=>1
         ]);
         /*verificar se o pokemon deve evoluir, subir de nivel ou apenas
         ganhar XP */
         //pokemon sobe de nivel e evolui
         if($this->pro->verifyLevelUp($this->pokeAtk) == 2){
           $this->pokeAtk = $this->pro->setStatusEvolution($this->pokeAtk);
           $this->log['pokeXP'] = 'evolution';
         }
         //pokemon sobe de nivel
         elseif($this->pro->verifyLevelUp($this->pokeAtk) == 1){
           $this->pokeAtk = $this->pro->setStatus($this->pokeAtk);
           $this->log['pokeXP'] = 'levelUp';
         }else{
           $this->log['pokeXP'] = 'gain';
         }
       }//if($this->pokeDef['hp'] < 1)


     }//if($this->case == 1)

     //caso o rival
     else{
       //pokemon do jogador foi derrotado
       if($this->statusDef['hp'] < 1){
         $this->log['SECOND']['log'][1] = $this->pokeDef['name'].' foi derrotado!';
         //trocar ou encerrar a batalha
         if( $this->pro->getIdPokemonBagByAlive($this->idPlayer) == 0 ){
           $this->log['battle'] = false;
         }else{
           $this->log['battle'] = 'switch';
         }
       }
     }


     // }//if($this->pokeRival['hp'] < 1)
     return $this->log;
   }//_rouundPVE

   /**
   * aplica o effeito de acordo com o nome do movimento,
   * e retorna o console
   * @param Int $move [identificador do ataque]
   * @return Array $effect[
   *                'model' => self || opponent || none
   *                'msg'   => descrição do efeito
   *               ]
   */
   function effectStatus($move){
     $effect['target'] = 'self';
     $effect['msg'] = '';
     switch ( strtolower($move['name']) ) {
       case 'growl':
         $a = $this->statusDef['atk'];
         $r = ($a/100);
         $r = ($r*10);
         $this->statusDef['atk'] = ($a-$r);
         $a = $this->statusDef['spAtk'];
         $r = ($a/100);
         $r = ($r*10);
         $this->statusDef['spAtk'] = ($a-$r);
         $effect['model'] = 'opponent';
         $effect['msg'] = "Ataque do ".$this->pokeDef['name']." foi reduzido";
        break;

       default:
         //!* Reportar problema
         //Nivel de gravidade Maxima
         $effect['msg'] = "movimento {$move['name']} não registrado em 'effectStatus'";
       break;
       return $effect;
     }
   }//effectStatus

   /**
   * aplica o effeito de acordo com o nome do movimento,
   * e retorna o console
   * @param Int $move [identificador do ataque]
   * @return Array $effect[
   *                'model' => self || opponent || none
   *                'msg'   => descrição do efeito
   *               ]
   */
   function effectAtk($move){
     $effect['target'] = 'none';
     $effect['msg'] = 'none';
     switch ( strtolower($move['name']) ) {
       case 'tackle':
         //effect --->
        break;
       default:
         //!* Reportar problema
         //Nivel de gravidade Maxima
         $effect['msg'] = "movimento {$move['name']} não registrado em 'effectAtks'";
       break;
     }//switch
     return $effect;
   }//effectAtks

   /**recebe $move['acc'](int) e verifica se houve acerto,
    * true acerto
   */
   function verifyAcc($move){
     //verifica se acc é 100% de acerto
     if($move['acc'] === 100){
       return true;
     }
     //randomiza a falha
     $fail = rand(1,100);
     //verifica se o ataque teve sucesso
     if($fail > $move['acc']){
       return false;
     }return true;
   }//verifyAcc

   /** !* INFO ERRADO faz um pokemon atacar.
    * @param Int $move [Id do poke agressor]
    * @param Array $move [ataque do agressor]
    *
    * @return Array $result [
    *    'oldHp'  => [hp que tinha],
    *    'damage' => [dano],
    *    'hp'     => [hp pós dado],
    *  ]
    * @return Boolean false
    *
    * @warning [$move['pwr'] deve ser um valor valido inteiro]
    * $Process->attack(10001,10002,$move);
    */
   function attack($move){
     //pega o movimento
     // $move = $this->pro->getMoveInPokemon($idPokeAtk);
     // $move = $move['list'][0];
     #======= fim parameter =========
     //verifica se o ataque errou
     if( !$this->verifyAcc($move) ){
       return 'fail';
     }
     // if($move['acc'] != 100){
     //   $acc  = rand(1,100); //50
     //   $fail = ((100)-($move['acc']));
     //
     //   //verifica se o ataque teve sucesso
     //   if($acc < $fail){
     //     return ['damage'=>'fail'];
     //   }
     // }
     //recebe o resultado do calculo
     $damage = $this->calcDamage($move);
     $hp = ($this->statusDef['hp'])-($damage);
     //se o hp for menor que 1, pokemon esta morto
     if( $hp < 1 ){
       $hp = 0;
     }
     //salva o hp para inserir no log como estava
     $oldHp = $this->statusDef['hp'];
     //insere o hp pós dano
     $this->statusDef['hp'] = $hp;

     //retorna o dano
     return $damage;

   }//attack
   // 'maxHP' => $hp,
   // 'oldHp' => $oldHp,

   /** calcDamage
   * Esta função calcula o dano do ataque
   *
   * @param Array $move [movimento que sera usado para ataque
   *               (passar o array puro)]
   * @param Array $pokeAtk [todos os dados do pokemon atacante]
   * @param Array $pokeDef [todos os dados do pokemon defensor]
   *
   * @return Int valor do dano(0 o pokeon defensor é imune)
   *
   * Descrição das veriáveis
   * $e   : efetividade
   * $r   : numero random de 0.58 a 1
   * $c   : critico
   * $out : outros
   * $stab: stab(x 1.5 de o pokemon atacante é do mesmo atributo do movimento)
   */
   function calcDamage($move){
     /*fire && Flying VS Grass && Poison
     // $pokeAtk = ['idType1'=>8,'idType2'=>0, 'level' => 50, 'atk' => 12,'spAtk' => 100];
     // $pokeDef = ['idType1'=>4,'idType2'=>5, 'def' => 12,'spDef' => 100];
     // $move = $this->getMoveInPokemon(10001);
     // $move = $move['list'][0];
     // $move['cat'] = 'spe';
     // $move['pwr'] = 90;
     // $move['idType'] = 8;*/
     ####### FIM PARAM #######

     //variáveis do delta
     $e = $this->pro->typeEffective($move['idType'],$this->pokeDef['idType1']);
     $r = (rand(85,100)/100);
     $c = 1;
     $out = 1;
     $stab = 1;
     //verifica se pokeDef tem outro tipo, se sim recalcular o $e
     if( $this->pokeAtk['type2'] != 0 ){
       $value = $e+($this->pro->typeEffective(
         $move['idType'],$this->pokeDef['idType2']));
       //verificando efetividade ($e) x2, x1, 0.5, x0.25
       //dano normal
       if( ($value==2.5) || ($value==2) ){
         $e = 1;
       }
       //dano x2
       elseif($value==3){
         $e = 2;
       }
       //dano x4
       elseif($value==4){
         $e = 4;
       }
       //dano 1/2
       elseif($value==1.5){
         $e = 0.5;
       }
       //dano 1/4
       else if($value==1){
         $e = 0.25;
       }
     }

     /* Verifica se um dos tipos do pokemon atacante é igual ao tipo do atk,
       se sim, o pokemon ganha mais 0.5 de bonus de atk*/
     if($move['idType'] == $this->pokeAtk['idType1']
      || $move['idType'] == $this->pokeAtk['idType2']){
       $stab = 1.5;
     }

     //calcula o delta
     $delt = ($stab*$e*$c*$out*$r);

     //variáveis de calculo, para multiplicar pelo delta($delt)
     $pwr = $move['pwr'];
     $atk = $this->statusAtk['atk'];
     $def = $this->statusDef['def'];
     $lv  = $this->pokeAtk['level'];
     //verifica qual o tipo do ataque
     if($move['cat'] == 'spe'){
       $atk = $this->statusAtk['spAtk'];
       $def = $this->statusDef['spDef'];
     }
     //calculo final
     $d  = (2*$lv+10);//*$delt;
     $d  = ($d/250);
     $d2 = ($atk/$def);
     $d3 = ($pwr+2);
     $d  = ($d*$d2);
     $d  = ($d*$d3);
     $d  = ($d*$delt);
     return intval($d);
   }//calcDamage

   //grava o log de erros(/v0.2/extensions/Game/log)
   function setLog($title,$function,$line,$objective,$msg){
     $texto = json_encode([
       'Document'  => 'Update.php',
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
     $arquivo = getcwd().'/v0.2/extensions/Game/log/Battle('.$line.')'.date("h:i:s_d-m-Y").'.json';
     // $arquivo = '/extensions/Game/log/error_'.date("d-m-Y").'.json';
     //Variável $fp armazena a conexão com o arquivo e o tipo de ação.
     $fp = fopen($arquivo, "a");
     //Escreve no arquivo aberto.
     fwrite($fp, $texto);
     //Fecha o arquivo.
     fclose($fp);
   }//setLog
}//Battle
