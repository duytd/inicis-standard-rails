<?php

namespace inicis\php;

error_reporting(E_ALL);
ini_set('display_errors', true);

if (!defined("DS"))
  define("DS", DIRECTORY_SEPARATOR);

define("INIPAYLIB", "lib" . DS . "INIPay");

require_once './lib/php/lib/Thrift/ClassLoader/ThriftClassLoader.php';
require_once(INIPAYLIB . DS . "INILib.php");
require_once(INIPAYLIB . DS . "INIStdPayUtil.php");
require_once(INIPAYLIB . DS . "inimx" . DS . "INImx.php");
require_once(INIPAYLIB . DS . "StdHttpClient.php");

use Thrift\ClassLoader\ThriftClassLoader;

$GEN_DIR = './gen-php';

$loader = new ThriftClassLoader();
$loader->registerNamespace('Thrift', './lib/php/lib');
$loader->registerDefinition('inicis', $GEN_DIR);
$loader->register();

if (php_sapi_name() == 'cli') {
  ini_set("display_errors", "stderr");
}

use Thrift\Protocol\TBinaryProtocol;
use Thrift\Transport\TPhpStream;
use Thrift\Transport\TBufferedTransport;

class InicisHandler implements \inicis\InicisIf {
  protected $log = array();
  protected $inipay;
  protected $inimx;
  protected $iniStdPayUtil;
  protected $stdHttpClient;

  public function __construct() {
    $this->inipay = new \INIpay50();
    $this->inimx = new \INImx();
    $this->iniStdPayUtil = new \INIStdPayUtil();
    $this->stdHttpClient = new \StdHttpClient();
  }

  public function getTimestamp() {
    return $this->iniStdPayUtil->getTimestamp();
  }

  public function makeSignature($oid, $price, $timestamp) {
    $params = array(
        "oid" => $oid,
        "price" => $price,
        "timestamp" => $timestamp
    );
    return $this->iniStdPayUtil->makeSignature($params, "sha256");
  }

  public function makePaymentAproveSignature($authToken, $timestamp) {
    $params = array(
        "authToken" => $authToken,
        "timestamp" => $timestamp
    );
    return $this->iniStdPayUtil->makeSignature($params, "sha256");
  }

  public function getAuthenticationResult(array $map, $url) {
     if ($this->stdHttpClient->processHTTP($url, $map)) {
        $authResultString = $this->stdHttpClient->body;
        return $authResultString;
      }
      else {
        return "http_connect_error";
      }
  }

  public function getMobileAuthenticationResult($inipayhome, $mid, $p_rmesg1, $p_tid, $p_status, $p_req_url, $p_noti) {
    $this->inimx->reqtype = "PAY";
    $this->inimx->inipayhome = $inipayhome;
    $this->inimx->id_merchant = $mid;
    $this->inimx->rmesg1 = $p_rmesg1;
    $this->inimx->tid = $p_tid;
    $this->inimx->status = $p_status;
    $this->inimx->req_url = $p_req_url;
    $this->inimx->noti = $p_noti;
    $this->inimx->startAction();
    $this->inimx->getResult();


    $a = json_encode(array(
      "m_resultCode" => $this->inimx->m_resultCode,
      "m_resultMsg" => mb_convert_encoding($this->inimx->m_resultMsg, "UTF-8", "CP949"),
      "m_payMethod" => $this->inimx->m_payMethod,
      "m_moid" => $this->inimx->m_moid,
      "m_tid" => $this->inimx->m_tid,
      "m_buyerName" => mb_convert_encoding($this->inimx->m_buyerName, "UTF-8", "CP949"),
      "m_resultprice" => $this->inimx->m_resultprice,
      "m_pgAuthDate" => $this->inimx->m_pgAuthDate,
      "m_pgAuthTime" => $this->inimx->m_pgAuthTime,
      "m_authCode" => $this->inimx->m_authCode,
      "m_cardQuota" => $this->inimx->m_cardQuota,
      "m_cardCode" => $this->inimx->m_cardCode,
      "m_cardIssuerCode" => $this->inimx->m_cardIssuerCode,
      "m_cardpurchase" => $this->inimx->m_cardpurchase,
      "m_prtc" => $this->inimx->m_prtc,
      "m_vacct" => $this->inimx->m_vacct,
      "m_vcdbank" => $this->inimx->m_vcdbank,
      "m_dtinput" => $this->inimx->m_dtinput,
      "m_tminput" => $this->inimx->m_tminput,
      "m_nmvacct" => mb_convert_encoding($this->inimx->m_nmvacct, "UTF-8", "CP949"),
      "m_nextUrl" => $this->inimx->m_nextUrl,
      "m_notiUrl" => $this->inimx->m_notiUrl
    ));
    error_log($a);

    return $a;
  }

  public function makeHash($signKey) {
    $iniStdPayUtil = new \INIStdPayUtil();
    return $iniStdPayUtil->makeHash($signKey, "sha256");
  }

  public function aes256_cbc_encrypt($key, $data, $iv) {
    if(32 !== strlen($key)) $key = hash('SHA256', $key, true);
    if(16 !== strlen($iv)) $iv = hash('MD5', $iv, true);
    $padding = 16 - (strlen($data) % 16);
    $data .= str_repeat(chr($padding), $padding);
    return bin2hex(mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_CBC, $iv));
  }

  public function aes256_cbc_decrypt($key, $data, $iv) {
    if(32 !== strlen($key)) $key = hash('SHA256', $key, true);
    if(16 !== strlen($iv)) $iv = hash('MD5', $iv, true);
    $data = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, hex2bin($data), MCRYPT_MODE_CBC, $iv);
    $padding = ord($data[strlen($data) - 1]);
    return substr($data, 0, -$padding);
  }
};

header('Content-Type', 'application/x-thrift');
if (php_sapi_name() == 'cli') {
  echo "\r\n";
}

$handler = new InicisHandler();
$processor = new \inicis\InicisProcessor($handler);

$transport = new TBufferedTransport(new TPhpStream(TPhpStream::MODE_R | TPhpStream::MODE_W));
$protocol = new TBinaryProtocol($transport, true, true);

$transport->open();
$processor->process($protocol, $protocol);
$transport->close();
