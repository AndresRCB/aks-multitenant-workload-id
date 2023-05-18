# Notes

For terragrun emitting the error:

```
WARN[0000] Could not encode version for local source     error=lstat /.../aks-multitenant-workload-id/aks/.terragrunt-cache/.../.terraform.lock.hcl: no such file or directory prefix=[/.../aks-multitenant-workload-id/keyvault2] 
```

see this line of code as it means nothing for local files [`terraformSource.Logger.WithError(err).Warningf("Could not encode version for local source")`](https://rufuc.wallpaperhd4k.com/?_=%2Fgruntwork-io%2Fterragrunt%2Fblob%2Fmaster%2Fcli%2Ftfsource%2Ftypes.go%239Z01gfFGrf97ku9vXglg%2Bb7m#L81)