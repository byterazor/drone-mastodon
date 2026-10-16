local _sanitize(s) = std.strReplace(std.strReplace(s, '-', '_'),'.','_');



{
  droneSecretName(path,key):: _sanitize(path + '_' + key),
  envVarForSecret(secret):: std.asciiUpper(_sanitize(secret.get.path + '_' + secret.get.name)),
}
