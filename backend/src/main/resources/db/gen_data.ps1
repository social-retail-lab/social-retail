$f = "H:\asocial\social-retail\backend\src\main\resources\db\update_social_retail_0707_data.sql"
$hm = @(2003,2004,2007,2010)
$tm = @(2001,2002,2005,2006,2008,2009,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025)
$N = 250

$hp = @{}
$hp["2003"] = @(@(6009,8009,36.90),@(6010,8010,49.90),@(6011,8011,118.00),@(6012,8012,85.00),@(6025,8025,128.00),@(6026,8026,59.90),@(6027,8027,39.90),@(6028,8028,68.00),@(6093,8093,198.00))
$hp["2004"] = @(@(6013,8013,68.00),@(6014,8014,22.90),@(6035,8035,28.90),@(6036,8036,68.00),@(6037,8037,78.00),@(6041,8041,45.90),@(6042,8042,88.00),@(6043,8043,198.00),@(6047,8047,58.00),@(6064,8064,98.00),@(6092,8092,298.00),@(6094,8094,288.00))
$hp["2007"] = @(@(6095,8095,398.00),@(6096,8096,48.00),@(6097,8097,598.00),@(6098,8098,168.00),@(6100,8100,198.00),@(6101,8101,88.00),@(6105,8105,88.00),@(6109,8109,45.00),@(6114,8114,398.00),@(6141,8141,128.00),@(6142,8142,298.00),@(6143,8143,398.00),@(6146,8146,68.00),@(6151,8151,998.00),@(6152,8152,128.00))
$hp["2010"] = @(@(6070,8070,168.00),@(6073,8073,1499.00),@(6074,8074,298.00),@(6080,8080,128.00),@(6081,8081,88.00),@(6082,8082,168.00),@(6084,8084,268.00),@(6085,8085,398.00),@(6086,8086,328.00),@(6087,8087,168.00),@(6088,8088,888.00),@(6089,8089,198.00))

$tp = @{}
$tp["2001"] = @(@(6001,8001,77.00),@(6002,8002,26.00),@(6003,8003,35.90),@(6004,8004,22.90))
$tp["2002"] = @(@(6005,8005,19.90),@(6006,8006,35.00),@(6007,8007,24.90))
$tp["2005"] = @(@(6017,8017,18.90),@(6018,8018,24.90),@(6057,8057,29.90))
$tp["2006"] = @(@(6021,8021,65.00),@(6022,8022,19.90),@(6067,8067,45.00))
$tp["2008"] = @(@(6128,8128,298.00),@(6131,8131,68.00),@(6138,8138,398.00))
$tp["2009"] = @(@(6153,8153,398.00),@(6157,8157,88.00),@(6167,8167,598.00))
$tp["2011"] = @(@(6169,8169,35.00),@(6170,8170,68.00))
$tp["2012"] = @(@(6171,8171,1499.00),@(6172,8172,599.00))
$tp["2013"] = @(@(6173,8173,168.00),@(6174,8174,58.00))
$tp["2014"] = @(@(6175,8175,2599.00),@(6176,8176,2999.00))
$tp["2015"] = @(@(6177,8177,24.90),@(6178,8178,12.90))
$tp["2016"] = @(@(6179,8179,198.00),@(6180,8180,268.00))
$tp["2017"] = @(@(6181,8181,8800.00),@(6182,8182,8900.00))
$tp["2018"] = @(@(6183,8183,5688.00),@(6184,8184,3298.00))
$tp["2019"] = @(@(6185,8185,188.00),@(6186,8186,288.00))
$tp["2020"] = @(@(6187,8187,598.00),@(6188,8188,1256.00))
$tp["2021"] = @(@(6189,8189,68.00),@(6190,8190,88.00))
$tp["2022"] = @(@(6191,8191,899.00),@(6192,8192,1299.00))
$tp["2023"] = @(@(6193,8193,88.00),@(6194,8194,168.00))
$tp["2024"] = @(@(6195,8195,398.00),@(6196,8196,188.00))
$tp["2025"] = @(@(6197,8197,8888.00),@(6198,8198,10000.00))

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("-- Auto-generated orders & earnings data")
[void]$sb.AppendLine("")

function Rand($a,$b){ return Get-Random -Minimum $a -Maximum $b }

$oid = 20000; $oit = 100000; $eid = 100000; $wid = 50000

$hc = [math]::Floor($N*0.70); $tc = $N-$hc
$hpc = [math]::Floor($hc/4)
$hcc = @($hpc,$hpc,$hpc,$hpc); $hcc[0]+=($hc-($hpc*4))
$tpc = [math]::Floor($tc/21); $tr = $tc-($tpc*21)
$tcc=@(); for($i=0;$i -lt 21;$i++){$c=$tpc;if($tr -gt 0){$c++;$tr--};$tcc+=$c}

# HEAD merchants
foreach($mid in $hm){
    $idx = [array]::IndexOf($hm,$mid)
    $cnt = $hcc[$idx]
    $pl = $hp["$mid"]
    for($i=0;$i -lt $cnt;$i++){
        $uid = Rand 1001 1026
        $rr = Rand 1 101
        if($rr -le 10){$st=1}elseif($rr -le 20){$st=2}elseif($rr -le 35){$st=3}elseif($rr -le 75){$st=4}else{$st=6}
        $dt = if((Rand 1 3) -eq 1){1}else{2}
        $ic = Rand 1 4
        $total=0; $items=@()
        for($j=0;$j -lt $ic;$j++){
            $p = $pl[(Rand 0 $pl.Count)]
            $q = Rand 1 4
            $iv = [math]::Round($p[2]*$q,2)
            $total += $iv
            $items += ,@($p[0],$p[1],$p[2],$q,$iv)
        }
        $disc = [math]::Round($total*(Rand 1 11)/100,2)
        $pay = [math]::Round($total-$disc,2)
        $d = Rand 0 61; if($d -gt 30){$d = Rand 0 31}
        $h=Rand 8 23;$m=Rand 0 60;$s=Rand 0 60
        $dto = (Get-Date).AddDays(-$d).AddHours($h).AddMinutes($m).AddSeconds($s)
        $ds = $dto.ToString('yyyy-MM-dd HH:mm:ss')
        $osn = "OD"+$dto.ToString('yyyyMMddHHmmss')+($oid%10000).ToString('0000')

        [void]$sb.AppendLine("INSERT INTO ``order`` (id,order_sn,user_id,merchant_id,total_amount,pay_amount,delivery_type,status,create_time) VALUES ($oid,'$osn',$uid,$mid,$total,$pay,$dt,$st,'$ds');")
        foreach($it in $items){
            [void]$sb.AppendLine("INSERT INTO order_item (id,order_id,sku_id,product_name,price,quantity) VALUES ($oit,$oid,$($it[1]),'Product#$($it[0])',$($it[2]),$($it[3]));")
            $oit++
        }
        if($st -eq 4){
            [void]$sb.AppendLine("INSERT INTO merchant_earnings (id,merchant_id,order_id,order_sn,amount,status,create_time) VALUES ($eid,$mid,$oid,'$osn',$pay,1,'$ds');")
            $eid++
        }
        $oid++
    }
}

# TAIL merchants
foreach($mid in $tm){
    $idx = [array]::IndexOf($tm,$mid)
    $cnt = $tcc[$idx]
    $pl = $tp["$mid"]
    for($i=0;$i -lt $cnt;$i++){
        $uid = Rand 1001 1026
        $rr = Rand 1 101
        if($rr -le 10){$st=1}elseif($rr -le 20){$st=2}elseif($rr -le 35){$st=3}elseif($rr -le 75){$st=4}else{$st=6}
        $dt = if((Rand 1 3) -eq 1){1}else{2}
        $ic = Rand 1 3
        $total=0; $items=@()
        for($j=0;$j -lt $ic;$j++){
            $p = $pl[(Rand 0 $pl.Count)]
            $q = Rand 1 3
            $iv = [math]::Round($p[2]*$q,2)
            $total += $iv
            $items += ,@($p[0],$p[1],$p[2],$q,$iv)
        }
        $disc = [math]::Round($total*(Rand 1 11)/100,2)
        $pay = [math]::Round($total-$disc,2)
        $d = Rand 0 61; if($d -gt 30){$d = Rand 0 31}
        $h=Rand 8 23;$m=Rand 0 60;$s=Rand 0 60
        $dto = (Get-Date).AddDays(-$d).AddHours($h).AddMinutes($m).AddSeconds($s)
        $ds = $dto.ToString('yyyy-MM-dd HH:mm:ss')
        $osn = "OD"+$dto.ToString('yyyyMMddHHmmss')+($oid%10000).ToString('0000')

        [void]$sb.AppendLine("INSERT INTO ``order`` (id,order_sn,user_id,merchant_id,total_amount,pay_amount,delivery_type,status,create_time) VALUES ($oid,'$osn',$uid,$mid,$total,$pay,$dt,$st,'$ds');")
        foreach($it in $items){
            [void]$sb.AppendLine("INSERT INTO order_item (id,order_id,sku_id,product_name,price,quantity) VALUES ($oit,$oid,$($it[1]),'Product#$($it[0])',$($it[2]),$($it[3]));")
            $oit++
        }
        if($st -eq 4){
            [void]$sb.AppendLine("INSERT INTO merchant_earnings (id,merchant_id,order_id,order_sn,amount,status,create_time) VALUES ($eid,$mid,$oid,'$osn',$pay,1,'$ds');")
            $eid++
        }
        $oid++
    }
}

# Withdrawal records
[void]$sb.AppendLine("")
[void]$sb.AppendLine("-- Withdrawal Records")
$cards = @(@(6222021234567890123,'Chen','ICBC'),@(6228489876543210987,'Wang','ABC'),@(6217001234567890567,'Li','CCB'),@(6212261234567890345,'Zhao','BCOM'),@(6225881234567890234,'Qian','CMB'))
$hwc=@(5,4,5,4); $twc=@(2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
$wsv=@(1,1,1,2,2,3)

foreach($mid in $hm){
    $idx = [array]::IndexOf($hm,$mid)
    $cnt = $hwc[$idx]
    for($j=0;$j -lt $cnt;$j++){
        $card = $cards[(Rand 0 5)]
        $amt = [math]::Round((Rand 2000 20001),2)
        $wst = $wsv[(Rand 0 6)]
        $da = Rand 1 61
        $at = (Get-Date).AddDays(-$da).ToString('yyyy-MM-dd HH:mm:ss')
        $pto = Rand 1 5
        if($wst -ne 1){ $pt = "'"+(Get-Date).AddDays(-$da+$pto).ToString('yyyy-MM-dd HH:mm:ss')+"'" }else{ $pt = 'NULL' }
        [void]$sb.AppendLine("INSERT INTO withdrawal_record (id,merchant_id,amount,bank_card_number,account_name,bank_name,status,remark,apply_time,process_time) VALUES ($wid,$mid,$amt,'$($card[0])','$($card[1])','$($card[2])',$wst,'tixian','$at',$pt);")
        $wid++
    }
}

foreach($mid in $tm){
    $idx = [array]::IndexOf($tm,$mid)
    $cnt = $twc[$idx]
    for($j=0;$j -lt $cnt;$j++){
        $card = $cards[(Rand 0 5)]
        $amt = [math]::Round((Rand 100 2001),2)
        $wst = $wsv[(Rand 0 6)]
        $da = Rand 1 61
        $at = (Get-Date).AddDays(-$da).ToString('yyyy-MM-dd HH:mm:ss')
        $pto = Rand 1 5
        if($wst -ne 1){ $pt = "'"+(Get-Date).AddDays(-$da+$pto).ToString('yyyy-MM-dd HH:mm:ss')+"'" }else{ $pt = 'NULL' }
        [void]$sb.AppendLine("INSERT INTO withdrawal_record (id,merchant_id,amount,bank_card_number,account_name,bank_name,status,remark,apply_time,process_time) VALUES ($wid,$mid,$amt,'$($card[0])','$($card[1])','$($card[2])',$wst,'tixian','$at',$pt);")
        $wid++
    }
}

[System.IO.File]::WriteAllText($f,$sb.ToString(),[System.Text.Encoding]::UTF8)
Write-Host "Done! Orders: $N, Withdrawals: $($wid-50000)"