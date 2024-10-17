unit API.Resources;

interface
uses
  System.Classes;

type
  TMemoryStreamHelper = class helper for TMemoryStream
    function DecodeBase64: TMemoryStream;
  end;


const
// https://www.freepik.com/icon/access-denied_12701462#fromView=resource_detail&position=28
{$REGION '  Base64 Icons .. '}
  GrantedIconBase64 =
  'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACx' + #13#10 +
  'jwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAhtSURBVHjazZgLUFTXGce/c+7dXZbHCqKNj0FT' + #13#10 +
  'xPCwOjUkIRAbYhgjYRcbMwWTMYnGNmmTtkJkom0ax5JpjTFNa2Mak/QxfYwxldAAApJoiRqeiWgk' + #13#10 +
  'uiyGSY22Rbrgi1122b33nv7vgooKCivYnlHuOeeex+9+r/OdZfR/Xliw85KScgw08T9G+bRRGAyn' + #13#10 +
  'fE1NTf7/OWBysi2026DO5Yzfy4h9nZiIJsGEINGB9n5UqpVI5UhbVVXvjQVct47H7zp4KyetADD3' + #13#10 +
  'MUHjBJEHs90AQ1OE449JMOYkIUoEkza11pUdxUwx5oDp6emy0xf+gEZsAyQ2jQnWzLgoVonqOXGn' + #13#10 +
  'pioQqDQZKOlYbTGeMzHtsMS0VUfqKveiro0lIEtIzbYy0t6EoMKEEK+pgrZ8HhN6cnZ7j0Xx0wQu' + #13#10 +
  'qVqvQs626RHupBPer2pMK2CMlgH0OEnSspaassYxA5w9zxrrV1kxNBVHnNYqEeoWs0sKVVT2KPoe' + #13#10 +
  'gkpjoFIIl9ogpz8ZI3zFvW4zhyn8BID5GLPPL6lL22qqnKMPmJMjJZ7wrBOMfsxI/NHg9uULi9Ho' + #13#10 +
  '19gvYG9LhW5/QnyBpwQ7nAEHkVB/NbyXfubmsplk5c9YPEOQ9rijvnLbqAPGpy2awkmtgpdOwOY2' + #13#10 +
  'R0P5wcRU2w/xaiNADgHyOSZ8BxWTkXNFu5tp/EWsNgnQ37HXV7ybcKc1j3F6BQ5U6KirfGEMALPm' + #13#10 +
  'wyHKMKTaJUIeipI9IYpKFVBrPOByW+rL/z5wnaQ7bQ9rjN6CWo9Bou+g7wH8n0WcLWup3bF91AET' + #13#10 +
  'U60r8PYtxIkXHXUVaxNTrDOhzGoAtDPNn2lv+ODUZRKPgO2th7SXw0nCIDkvPnC7LIlnPqupOD3q' + #13#10 +
  'gAl3ZedDXb8UmljlaKjYNCslK1GVOADpKDeYrfa9Ra4rpb4oggnlbmJcl/IXRqO059De0jPBwg0K' + #13#10 +
  'GIh7SsQUSOIZNPPgIJsRXuDJNF0wvgneeQLSWcNJeIa/CxOqys9qwn+s7eOqc0EDfi0l+yaFi5Xo' + #13#10 +
  '/BZOsBjYkhlAvQDyYyTva0OmxLxQ9chOCUY9mH8QNvzK7Ckh1UVFReqIABHzohDzNuO0yAVUO2Os' + #13#10 +
  'GZLruR71XBQgzh5BMRDkHHxcF2z0yZba8ioaxlF4ATApLXs5gLag54BQxUpPiOvIzUTKaAC6XC7m' + #13#10 +
  '5jEWxMYnIIC12HY/+eUHHZ+UdA0LEKmTUYv0bMUHZcHzliKElIwG2OUl7o5MiyzLxdj0dkjRZq8t' + #13#10 +
  'rxkeYHpOuObzVKI6k6s8w/5xmf1aE3WP1ZgaKxE3w2H+PWuK+V/DsCuWmGbdDDU/CUkucdRWvDcs' + #13#10 +
  'wL4Ypu6ERcRqTJqPVKn1anNuSbXdJvWpKgVtkx4bceL8nhnNbwwWfgbOTUizbsLjKRjfw6115cWj' + #13#10 +
  'DjgTCYSssr/Cy+dg+qeY04nuWyERC9rPOxYk/5oKC4dKscYeMCHNtgpB+CVUt0oaW9Mdcu6s2ReW' + #13#10 +
  'AVf9AxbrEJJxoeOj99qvmCiQD223RM4omvuy5JUf80b1Pn18Res2usfpBoUYHUBk1gm7mn6rZzMI' + #13#10 +
  'hjmtDeU79O45CxaE+VymHQgjs7HXAntd5acX5uwnA3WOn0sKz8Vu82SPlCAr3OIzqe2aUWsB+Qc4' + #13#10 +
  'eYqp0fkPKrwyuR2pBHUVbYS95WPmasdU86sEx4hP+ebNjCvleG9hBspo2VfxeWB0lWU8+Q15GPsE' + #13#10 +
  'pk7Cc7CjVXcsB+L+BuJRRZTV1ns9gJSUmn2vYBqyE+ZB8P0NstPjmkZLsNL9kMY7Ls383X82vOsJ' + #13#10 +
  'wCmGl6H6RzDNeC1bQzkD+RWSp/N1yiVf8ICImWKcZyWqqwE0HiFD/6erpkZSxQ+ONFa2BNTaHv08' + #13#10 +
  'DscfDRPuvJ0icItvk62rjPpPmWDCTF9gt3hSiYtfIbAngfDnJPt+5/jo/T7nqBp/BymsBNKbfG0o' + #13#10 +
  'gbDEzoBEHyuhXUPc8CBlnXQGDaiX5ORkQ49xkp7K36cKfv/Rhh21/VLgtHPCRqhr1RA2NxDOiY/Q' + #13#10 +
  '7y8HMPIv6EkkPUsS4hGynfrb2ACWj4siZtiJWko/MC5VetLBQtHil8LxNeR2bqWwibejvQ00Mf1z' + #13#10 +
  'XqNPOvN0rx4DwK/E4ir8ITab1j90N9rwfP4U+hb1q/EiXChCEDH9WjvnvMBkTVRN7Qxf/OXjX3qv' + #13#10 +
  'D9A0+W1stlAjObO1vrQu8KIsOgFyqr5gf4JKyKQuJy8Lh9PgFKF5EORzQ8HpJUShPbeclWzNj3W4' + #13#10 +
  'gwbU1ZVwl3UllLBAaP7vtza+fyzQuytqGvVyHXBGvy69WPd16tFeoEgehgASTz1dtUPBUZ8dlMa2' + #13#10 +
  'RS5py2vrDbzQTwK/21iBAJykCSmjtaH0s2EABrzZF94dgjS+m84nnx9ODKceoadrGQO84SJkzulz' + #13#10 +
  'VAEvHwKubx2xnrK61upHYOClfg/p8IW/gY5H0ZHfUnfbm0SFwf2mgphD5dHPQp3rA/Z2oR+QOK9R' + #13#10 +
  '0W0VMXRQOL0gYIvFlN21hwYOiE+1LkRq/jaq3djjp0Khvdwke0dG10Oce7vta+w3AaiU9HvxpfD4' + #13#10 +
  'aP1+w0xDfJwe9ItIllfQwg73JYBxmZkmwzmpAENWo1eP/idR99FIClSCmLJPmtpdYF92GBd3/Y5D' + #13#10 +
  'kSNYwYGTeSkt6jxwcckBZXp6ekioLyITn4Lzk8XBAAw0kh85camBhe8Li2IFTU87VBJnvoc+2BKL' + #13#10 +
  'vvq8gGG0EtPyqPHU7oFZzaCb69LkHjlC7tHkkQiQc0lwj9fV3LwroB7aDk1ERGdCKs9ip2TSr61X' + #13#10 +
  'gp3tS7nYBmrsPHR5yhXsb9QjKYwqJ00gzfcNfMJ82FgcukLQr4MdBs5u8vD9lOt0DT75RpZ1MIB7' + #13#10 +
  'phvJ55VoaocfLuS/WjZ94wGDKP8FNDIKZaXM0NQAAAAASUVORK5CYII=';

  DeniedIconBase64  =
  'iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAARnQU1BAACx' + #13#10 +
  'jwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAiWSURBVHjazZgNXJXVHcf/5zzPvXCFi5puKgtB' + #13#10 +
  'wngx/axoEeTio3xQ8kKzNjSnRlZaLQOST7YX/Tj2Ys7WMmnTWltlMytiCgJhNhTkzdRME7gYS8o2' + #13#10 +
  'ckwTuXC5L89z9juXqyLShCu0PXi955znf875Pv+3838uo//zi/k6LyYm3UDf+JdR/dIoDIYzzkOH' + #13#10 +
  'Drn+54CxsakjOgzajZzxmYzYt4mJMSSYECROoX8QjXL3KHd9c1mZ4+sFXLOGR+4+fBMnPQcws5ig' + #13#10 +
  'kYLIjtmdAENXBOI/P8FYGwmxQzBlQ1NN0XHMFMMOmJiYqLY5A+fqxNZBYxOZYEcZFwUaUS0n3qZr' + #13#10 +
  'bihUmQCURKx2F74nY9oxhekr6mtKK9DWhxOQRcWnWRjpL0BRAUKI5zVBmz4OGfHF1NauILeLxnJF' + #13#10 +
  '0x1uamsONXfGnOyepDM9hzHKAOhnpCgZjVVF+4cNcOp0S7hLYwWwVARxWu02a5tMNmWEW2OLMXYP' + #13#10 +
  'TBoCk0K51Aw9vWo0OwscnSYOV/gZALMhU+lStIXNVWVtQw+Ynq5En7SvEYx+wki8Yuh0Zosgo9Gl' + #13#10 +
  's9/C3xYK6X9CfIJvBX54HQJEQXtjoIN+1clVE6nuLVg8SZC+xFpbum3IASMT7gzmpJUhSsdi81Rr' + #13#10 +
  'XfHh6PjUx3BrPUCOAPKnTDgPu/2MnLv125nOn8Jq4wH9YENtydtRt1qyGGfPADDXWlP6i2EAnDMD' + #13#10 +
  'AVEEkXKb8L9ntGr3d2tUArNGAm5eY23x33qvE3Nr6gKd0Yswaws0+gbG5uIzhTjLaKze+daQA0bH' + #13#10 +
  'W+7H3ReRJ56y1pSsjo6zTIYxywHQynRXSkPdu2f6aNwM31sLbd+HIAlA6unGA76lKuLxj6pKvhxy' + #13#10 +
  'wKjb0rJhrt8JXayw1pVsmBI3J1pTOADpODeYLA0V+bbLtX6nmQn37cS41PInRqOy90hF4Vlf4foF' + #13#10 +
  '9OQ9tzkYmngc3SwESB7SCyKZQgXjGxCdJ6GdJzkJ+8B3YULTeLsuXC3N75ed8xnwhri0cW4uMjH4' + #13#10 +
  'A5xgIfAlE4AcAHJBkvf0oVNi3TD14E4JRl2Yfxg+/MzUYP/y/Px8bVCAyHmjkfPycFrMA1QrY+wo' + #13#10 +
  'NNd1Nea5qECcPYJCoMhpeLjT8NFljdXFZTSAo/ACYExC2n0A2oSRD4QmMu3+tvowIvdQANpsNtbJ' + #13#10 +
  'Q4KQG5dCAaux7UFyqXdbD+w4PSBAlE5GfZR9Kx5oDiJvIVLIjqEA63tF3JISpKpqATb9DrSY2lBd' + #13#10 +
  'XDUwwMT0QN1pL0VzMtd4UsP7RQ1XmigjVmdauELchID555Rg0z8G4FcsOsGSBzMvgybnW6tLtg8I' + #13#10 +
  'sCeHae/AI8J1psxAqdT03+ZcH596s9Jjqjj0/WRuxInzJ2Y0be4v/fSeG5Vg2YCvR+B8C5pqiguG' + #13#10 +
  'HHAyCghVY28iyqdh+oeY828M3wSNBKG/ypoc+xzl5n5ViTX8gFEJqSuQhH+D5lZFZ092+J9rNzkD' + #13#10 +
  'khCqf8Zip4RinG3dt7217zyxhnh7PY166Mz0p226eu+1auePNo8+sI3yZdH71dE8OEBU1lG7D/1R' + #13#10 +
  'VjNIhulNdcU75fC05OQAp81vJ9LIVCT25Iaa0g8vgC0jg+imG9Gch8/0Dl2NcgglyMzdrX5MawTB' + #13#10 +
  'u9i3gE2iEyz38uJ2sBqUJloPf8vGzJXWb5k2EgIjMu57YYy7i3E/iBkoqbGy5GMprD9A15CLsiC7' + #13#10 +
  'FN3xrJ+TC6qTgWVFYx2NpHyeR46rAaSY+LSZgumoTpgdyff3qE4/03Waj5XuwHZv2HTTQ5/XvW33' + #13#10 +
  'wj2N8UXYxHglX8NaZyGby7roDyyfnL4DImeKkfZMNFdi2WuQMuQ/aZoqRRPL6/eXNnrNugqr/1jC' + #13#10 +
  'Cako/CH38f40CBnF2z4NIz/AXqOi837pS5rpSexB9nji4lkk9hgQ/ppU50vWfbs8waHfS7dg5R1Y' + #13#10 +
  'fIIXrhBo+7D5Y4AM88LI8RrIbcP3wxi/wTteBdm7+cvU5jOgvGJjYw1dxvGylJ+lCX7H8bqd1Z4N' + #13#10 +
  'EK3iBK3Hyiukz8F0OjZ8goXSRtFCsyGSh33CAFQJvT+C8uNTaHsL+t/3AsrX2UX8Ffrr8AD+kEYL' + #13#10 +
  'A72DheN6+VcLdlrOwmiX+JRmYZ9FwP4lUFoogJajvxqA5l5mfx6yWTKqhx5wCYVDM3uw8MQ+QXAR' + #13#10 +
  '8u84fbqBKOGIVkE2qI9sGYDvYq9S99UB+k14HavN1klNaaotrPEsnkFR0EC59L8+m0qnfxNYD/K/' + #13#10 +
  'UKf3QbZDbtplgSNoL+RSpZzPgLh41G2WTBghWeiuR5v272rxLL6YJgruAbyul8lwMsLnBHyO0wn4' + #13#10 +
  'ZDAZUJk7YG74JGQnXQJICKpTNJ+XkcMDKE8CV6exBMvE6EJJaqor/GgAgJ5odgZ2+KOM7yBvWhDp' + #13#10 +
  'FChMiGBGSb00Uo27S3v53GKS79vS3DJwBG2G/LXnHwZ/a9kW+KV8MDko30NOOQM3Y9JiDGQ31tz8' + #13#10 +
  'AlGuT7+pCBm5GfQEmmtlfvNEMaNM5kcvQ2OPnve5Cz55mvaIMfQSxhZ4H+as1//2yv6Foycy3jIb' + #13#10 +
  'pfnraHYgr/1cuKmC+6ndg8PrIs67O46FVozDyoVMvhf3bHoMX9JtZl0SrYI+h9w+PNVMjI8TPVbI' + #13#10 +
  'x+F3v/S/SwAjUlL8DOeUHIisxKg8mr5A2zkoPuZRYOU3DR05e0Ir5nr8i9GoAWtf4EzWaCHfSh9c' + #13#10 +
  'XLLXFZqY6D/CaU6B6CLcioADGGgwP3IKz5teZYCT5RxIKNaogx725DiiMVdwC+l3UsNZqGre613V' + #13#10 +
  '9Lu51Ca3q2a1S1cHo0DOFcHt3bajR3d7zIOAMSJgUrCL9MlYbGbqB6zdU3LptI6F05G+JZevv1EP' + #13#10 +
  'XKkyaJbQWDS+i88MfCIw7I+d29E+Bhd4D657EBVMv68Kww54CSzOacSuUWikMAeKsXxysSu8G3+t' + #13#10 +
  'gL5c/wH3BStlCrQucwAAAABJRU5ErkJggg==';
{$ENDREGION}

implementation
uses
  System.NetEncoding,
  System.SysUtils;

{ TMemoryStreamHelper }
function TMemoryStreamHelper.DecodeBase64: TMemoryStream;
var
  LOutput: TMemoryStream;
begin
  LOutput := TMemoryStream.Create;
  try
    Position := 0;

    TNetEncoding.Base64.Decode(Self, LOutput);
    LOutput.Position := 0;
    Clear;
    LOutput.SaveToStream(Self);
  finally
    LOutput.Free;
  end;
  Position := 0;
  Result := Self;
end;

end.
