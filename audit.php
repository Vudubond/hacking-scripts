<?php 


/*
  * Script d'audit infra web. 
  * DNS : dig, reverse, fierce 
  * todo parse results .txt -> json 
  * todo recup ip if DOMAIN param 
  * todo : nmap on IP 



*/

global $argc, $argv;

class AuditInfraWeb {


	private $domain ="";
	private $ip = "";

	public function __construct($argv){
		if(isset($argv[1]) && !empty($argv[1]))
		$this->domain= $argv[1];
	}


	public function auditDNS(){
		echo "\r\nAudit DNS pour : ".$this->domain."......... \r\n";
		//$this->ping();
		$this->dig();
		$this->digReverse();
		$this->fierce();

	}


	private function runSystemCmd($cmd){
		echo "\r\n".$cmd."\r\n";
		system($cmd);
	}


	private function ping(){
		$cmd ="ping ".$this->domain;
		$this->runSystemCmd($cmd);
	}


	private function dig(){
		$cmd= "dig ".$this->domain." >> dig.txt";
		$this->runSystemCmd($cmd);
	}

	// todo on ip addr
	private function digReverse(){
		$reverse_domain = implode(".",array_reverse(explode(".",$this->domain)));
		$cmd = "dig ".$reverse_domain.".in-addr.arpa PTR >> dig-reverse.txt";
		$this->runSystemCmd($cmd);
	}

	private function fierce(){
		$cmd = "fierce -dns ".$this->domain." >> fierce.txt";
		$this->runSystemCmd($cmd);
	}
}


function main($argc,$argv){
        $audit= new AuditInfraWeb($argv);
        $audit->auditDNS();
}

main($argc,$argv);


?>
