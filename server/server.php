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
  protected $iniStdPayUtil;
  protected $stdHttpClient;

  public function __construct() {
    $this->inipay = new \INIpay50;
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

  public function makeHash($signKey) {
    $iniStdPayUtil = new \INIStdPayUtil();
    return $iniStdPayUtil->makeHash($signKey, "sha256");
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
