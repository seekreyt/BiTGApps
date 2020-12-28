#!/sbin/sh
#
##############################################################
# File name       : 90-bitgapps.sh
#
# Description     : BiTGApps OTA survival script
#
# Build Date      : Monday December 07 04:25:52 IST 2020
#
# BiTGApps Author : TheHitMan @ xda-developers
#
# Copyright       : Copyright (C) 2020 TheHitMan7 (Kartik Verma)
#
# License         : SPDX-License-Identifier: GPL-3.0-or-later
##############################################################
# The BiTGApps scripts are free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# These scripts are distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
##############################################################

# ADDOND_VERSION=2

TMP=/tmp
SQLITE_TOOL=$S/xbin/sqlite3

trampoline() {
  ps | grep zygote | grep -v grep >/dev/null && BOOTMODE=true || BOOTMODE=false
  $BOOTMODE || ps -A 2>/dev/null | grep zygote | grep -v grep >/dev/null && BOOTMODE=true
  if ! $BOOTMODE; then
    # update-binary|updater <RECOVERY_API_VERSION> <OUTFD> <ZIPFILE>
    OUTFD=$(ps | grep -v 'grep' | grep -oE 'update(.*) 3 [0-9]+' | cut -d" " -f3)
    [ -z $OUTFD ] && OUTFD=$(ps -Af | grep -v 'grep' | grep -oE 'update(.*) 3 [0-9]+' | cut -d" " -f3)
    # update_engine_sideload --payload=file://<ZIPFILE> --offset=<OFFSET> --headers=<HEADERS> --status_fd=<OUTFD>
    [ -z $OUTFD ] && OUTFD=$(ps | grep -v 'grep' | grep -oE 'status_fd=[0-9]+' | cut -d= -f2)
    [ -z $OUTFD ] && OUTFD=$(ps -Af | grep -v 'grep' | grep -oE 'status_fd=[0-9]+' | cut -d= -f2)
  fi;
  ui_print() { echo -e "ui_print $1\nui_print" >> /proc/self/fd/$OUTFD; }
}

# Set defaults
. /tmp/backuptool.functions

cts_defaults() {
  # CTS defaults
  CTS_DEFAULT_SYSTEM_EXT_BUILD_FINGERPRINT="ro.system.build.fingerprint=";
  CTS_DEFAULT_SYSTEM_EXT_BUILD_ID="ro.system.build.id=";
  CTS_DEFAULT_SYSTEM_EXT_BUILD_TAG="ro.system.build.tags=";
  CTS_DEFAULT_SYSTEM_EXT_BUILD_TYPE="ro.system.build.type=";
  CTS_DEFAULT_SYSTEM_BUILD_FINGERPRINT="ro.build.fingerprint=";
  CTS_DEFAULT_SYSTEM_BUILD_SEC_PATCH="ro.build.version.security_patch=";
  CTS_DEFAULT_SYSTEM_BUILD_TYPE="ro.build.type=";
  CTS_DEFAULT_SYSTEM_BUILD_TAG="ro.build.tags=";
  CTS_DEFAULT_SYSTEM_BUILD_DESC="ro.build.description=";
  CTS_DEFAULT_PRODUCT_BUILD_FINGERPRINT="ro.product.build.fingerprint=";
  CTS_DEFAULT_PRODUCT_BUILD_ID="ro.product.build.id=";
  CTS_DEFAULT_PRODUCT_BUILD_TAG="ro.product.build.tags=";
  CTS_DEFAULT_PRODUCT_BUILD_TYPE="ro.product.build.type=";
  CTS_DEFAULT_EXT_BUILD_FINGERPRINT="ro.system_ext.build.fingerprint=";
  CTS_DEFAULT_EXT_BUILD_ID="ro.system_ext.build.id=";
  CTS_DEFAULT_EXT_BUILD_TAG="ro.system_ext.build.tags=";
  CTS_DEFAULT_EXT_BUILD_TYPE="ro.system_ext.build.type=";
  CTS_DEFAULT_VENDOR_BUILD_SEC_PATCH="ro.vendor.build.security_patch=";
  CTS_DEFAULT_VENDOR_EXT_BUILD_FINGERPRINT="ro.vendor.build.fingerprint=";
  CTS_DEFAULT_VENDOR_BUILD_FINGERPRINT="ro.build.fingerprint=";
  CTS_DEFAULT_VENDOR_BUILD_ID="ro.vendor.build.id=";
  CTS_DEFAULT_VENDOR_BUILD_TAG="ro.vendor.build.tags=";
  CTS_DEFAULT_VENDOR_BUILD_TYPE="ro.vendor.build.type=";
  CTS_DEFAULT_VENDOR_BUILD_BOOTIMAGE="ro.bootimage.build.fingerprint=";
  # CTS patch
  patch_v29() {
    CTS_SYSTEM_EXT_BUILD_FINGERPRINT="ro.system.build.fingerprint=google/coral/coral:10/QQ3A.200805.001/6578210:user/release-keys";
    CTS_SYSTEM_EXT_BUILD_ID="ro.system.build.id=QQ3A.200805.001";
    CTS_SYSTEM_EXT_BUILD_TAG="ro.system.build.tags=release-keys";
    CTS_SYSTEM_EXT_BUILD_TYPE="ro.system.build.type=user";
    CTS_SYSTEM_BUILD_FINGERPRINT="ro.build.fingerprint=google/coral/coral:10/QQ3A.200805.001/6578210:user/release-keys";
    CTS_SYSTEM_BUILD_SEC_PATCH="ro.build.version.security_patch=2020-08-05";
    CTS_SYSTEM_BUILD_TYPE="ro.build.type=user";
    CTS_SYSTEM_BUILD_TAG="ro.build.tags=release-keys";
    CTS_SYSTEM_BUILD_DESC="ro.build.description=coral-user 10 QQ3A.200805.001 6578210 release-keys";
    CTS_PRODUCT_BUILD_FINGERPRINT="ro.product.build.fingerprint=google/coral/coral:10/QQ3A.200805.001/6578210:user/release-keys";
    CTS_PRODUCT_BUILD_ID="ro.product.build.id=QQ3A.200805.001";
    CTS_PRODUCT_BUILD_TAG="ro.product.build.tags=release-keys";
    CTS_PRODUCT_BUILD_TYPE="ro.product.build.type=user";
    CTS_EXT_BUILD_FINGERPRINT="ro.system_ext.build.fingerprint=google/coral/coral:10/QQ3A.200805.001/6578210:user/release-keys";
    CTS_EXT_BUILD_ID="ro.system_ext.build.id=QQ3A.200805.001";
    CTS_EXT_BUILD_TAG="ro.system_ext.build.tags=release-keys";
    CTS_EXT_BUILD_TYPE="ro.system_ext.build.type=user";
    CTS_VENDOR_BUILD_SEC_PATCH="ro.vendor.build.security_patch=2020-08-05";
    CTS_VENDOR_EXT_BUILD_FINGERPRINT="ro.vendor.build.fingerprint=google/coral/coral:10/QQ3A.200805.001/6578210:user/release-keys";
    CTS_VENDOR_BUILD_FINGERPRINT="ro.build.fingerprint=google/coral/coral:10/QQ3A.200805.001/6578210:user/release-keys";
    CTS_VENDOR_BUILD_ID="ro.vendor.build.id=QQ3A.200805.001";
    CTS_VENDOR_BUILD_TAG="ro.vendor.build.tags=release-keys";
    CTS_VENDOR_BUILD_TYPE="ro.vendor.build.type=user";
    CTS_VENDOR_BUILD_BOOTIMAGE="ro.bootimage.build.fingerprint=google/coral/coral:10/QQ3A.200805.001/6578210:user/release-keys";
  }
  patch_v30() {
    CTS_SYSTEM_EXT_BUILD_FINGERPRINT="ro.system.build.fingerprint=google/coral/coral:11/RQ1A.201205.008/6943376:user/release-keys";
    CTS_SYSTEM_EXT_BUILD_ID="ro.system.build.id=RQ1A.201205.008";
    CTS_SYSTEM_EXT_BUILD_TAG="ro.system.build.tags=release-keys";
    CTS_SYSTEM_EXT_BUILD_TYPE="ro.system.build.type=user";
    CTS_SYSTEM_BUILD_FINGERPRINT="ro.build.fingerprint=google/coral/coral:11/RQ1A.201205.008/6943376:user/release-keys";
    CTS_SYSTEM_BUILD_SEC_PATCH="ro.build.version.security_patch=2020-12-05";
    CTS_SYSTEM_BUILD_TYPE="ro.build.type=user";
    CTS_SYSTEM_BUILD_TAG="ro.build.tags=release-keys";
    CTS_SYSTEM_BUILD_DESC="ro.build.description=coral-user 11 RQ1A.201205.008 6943376 release-keys";
    CTS_PRODUCT_BUILD_FINGERPRINT="ro.product.build.fingerprint=google/coral/coral:11/RQ1A.201205.008/6943376:user/release-keys";
    CTS_PRODUCT_BUILD_ID="ro.product.build.id=RQ1A.201205.008";
    CTS_PRODUCT_BUILD_TAG="ro.product.build.tags=release-keys";
    CTS_PRODUCT_BUILD_TYPE="ro.product.build.type=user";
    CTS_EXT_BUILD_FINGERPRINT="ro.system_ext.build.fingerprint=google/coral/coral:11/RQ1A.201205.008/6943376:user/release-keys";
    CTS_EXT_BUILD_ID="ro.system_ext.build.id=RQ1A.201205.008";
    CTS_EXT_BUILD_TAG="ro.system_ext.build.tags=release-keys";
    CTS_EXT_BUILD_TYPE="ro.system_ext.build.type=user";
    CTS_VENDOR_BUILD_SEC_PATCH="ro.vendor.build.security_patch=2020-12-05";
    CTS_VENDOR_EXT_BUILD_FINGERPRINT="ro.vendor.build.fingerprint=google/coral/coral:11/RQ1A.201205.008/6943376:user/release-keys";
    CTS_VENDOR_BUILD_FINGERPRINT="ro.build.fingerprint=google/coral/coral:11/RQ1A.201205.008/6943376:user/release-keys";
    CTS_VENDOR_BUILD_ID="ro.vendor.build.id=RQ1A.201205.008";
    CTS_VENDOR_BUILD_TAG="ro.vendor.build.tags=release-keys";
    CTS_VENDOR_BUILD_TYPE="ro.vendor.build.type=user";
    CTS_VENDOR_BUILD_BOOTIMAGE="ro.bootimage.build.fingerprint=google/coral/coral:11/RQ1A.201205.008/6943376:user/release-keys";
  }
}

# insert_line <file> <if search string> <before|after> <line match string> <inserted line>
insert_line() {
  local offset line;
  if ! grep -q "$2" $1; then
    case $3 in
      before) offset=0;;
      after) offset=1;;
    esac;
    line=$((`grep -n "$4" $1 | head -n1 | cut -d: -f1` + offset));
    if [ -f $1 -a "$line" ] && [ "$(wc -l $1 | cut -d\  -f1)" -lt "$line" ]; then
      echo "$5" >> $1;
    else
      sed -i "${line}s;^;${5}\n;" $1;
    fi;
  fi;
}

# Database optimization using sqlite tool
sqlite_opt() {
  for i in `find /d* -iname "*.db" 2>/dev/null;`; do
    # Running VACUUM
    $SQLITE_TOOL $i 'VACUUM;';
    resVac=$?
    if [ $resVac == 0 ]; then
      resVac="SUCCESS";
    else
      resVac="ERRCODE-$resVac";
    fi;
    # Running INDEX
    $SQLITE_TOOL $i 'REINDEX;';
    resIndex=$?
    if [ $resIndex == 0 ]; then
      resIndex="SUCCESS";
    else
      resIndex="ERRCODE-$resIndex";
    fi;
  done
}

# Create temporary dir
tmp_dir() {
  test -d $TMP/app || mkdir -p $TMP/app
  test -d $TMP/bin || mkdir -p $TMP/bin
  test -d $TMP/priv-app || mkdir -p $TMP/priv-app
  test -d $TMP/etc || mkdir -p $TMP/etc
  test -d $TMP/default-permissions || mkdir -p $TMP/default-permissions
  test -d $TMP/permissions || mkdir -p $TMP/permissions
  test -d $TMP/preferred-apps || mkdir -p $TMP/preferred-apps
  test -d $TMP/sysconfig || mkdir -p $TMP/sysconfig
  test -d $TMP/framework || mkdir -p $TMP/framework
  test -d $TMP/lib || mkdir -p $TMP/lib
  test -d $TMP/lib64 || mkdir -p $TMP/lib64
  test -d $TMP/xbin || mkdir -p $TMP/xbin
  test -d $TMP/addon || mkdir -p $TMP/addon
  test -d $TMP/addon/app || mkdir -p $TMP/addon/app
  test -d $TMP/addon/priv-app || mkdir -p $TMP/addon/priv-app
  test -d $TMP/addon/core || mkdir -p $TMP/addon/core
  test -d $TMP/addon/lib || mkdir -p $TMP/addon/lib
  test -d $TMP/addon/lib64 || mkdir -p $TMP/addon/lib64
  test -d $TMP/rwg || mkdir -p $TMP/rwg
  test -d $TMP/rwg/app || mkdir -p $TMP/rwg/app
  test -d $TMP/rwg/priv-app || mkdir -p $TMP/rwg/priv-app
  test -d $TMP/rwg/permissions || mkdir -p $TMP/rwg/permissions
  test -d $TMP/fboot/priv-app || mkdir -p $TMP/fboot/priv-app
  test -d $TMP/fboot/lib64 || mkdir -p $TMP/fboot/lib64
}

# Set default Android SDK
on_sdk() {
  supported_sdk_v30="30";
  supported_sdk_v29="29";
  supported_sdk_v28="28";
  supported_sdk_v27="27";
  supported_sdk_v25="25";
}

# Set partition and boot slot property
on_partition_check() {
  system_as_root=`getprop ro.build.system_root_image`
  active_slot=`getprop ro.boot.slot_suffix`
  AB_OTA_UPDATER=`getprop ro.build.ab_update`
  dynamic_partitions=`getprop ro.boot.dynamic_partitions`
  dynamic_partitions_retrofit=`getprop ro.boot.dynamic_partitions_retrofit`
}

# Set fstab for getting mount point
on_fstab() {
  # No fstab check required for OTA survival script
  fstab="/etc/fstab";
}

# Set vendor mount point
vendor_mnt() {
  device_vendorpartition="false";
  if [ -d /vendor ] && [ -n "$(cat $fstab | grep /vendor)" ]; then
    device_vendorpartition="true";
    VENDOR="/vendor";
  fi;
}

# Detect A/B partition layout https://source.android.com/devices/tech/ota/ab_updates
ab_partition() {
  device_abpartition="false";
  if [ ! -z "$active_slot" ]; then
    device_abpartition="true";
  fi;
  if [ "$AB_OTA_UPDATER" == "true" ]; then
    device_abpartition="true";
  fi;
}

# Detect system-as-root https://source.android.com/devices/bootloader/system-as-root
system_as_root() {
  SYSTEM_ROOT="false";
  if [ "$system_as_root" == "true" ]; then
    SYSTEM_ROOT="true";
  fi;
}

# Detect dynamic partition layout https://source.android.com/devices/tech/ota/dynamic_partitions/implement
super_partition() {
  dynamic_partitions="false";
  if [ "$dynamic_partitions" == "true" ]; then
    dynamic_partitions="true";
  fi;
}

# Mount partitions
mount_all() {
  vendor_mnt;
  mount -o bind /dev/urandom /dev/random
  mount -o ro -t auto /cache 2>/dev/null;
  mount -o rw,remount -t auto /cache
  mount -o ro -t auto /persist 2>/dev/null;
  # Set our own system mount point
  unset ANDROID_ROOT
  if [ "$dynamic_partitions" == "true" ]; then
    test -d "/system_root" && local ANDROID_ROOT="/system_root" || local ANDROID_ROOT="/system";
    if [ "$device_abpartition" == "true" ]; then
      for block in system product vendor; do
        for slot in "" _a _b; do
          blockdev --setrw /dev/block/mapper/$block$slot 2>/dev/null;
        done
      done
      for block in system_ext; do
        blockdev --setrw /dev/block/mapper/$block 2>/dev/null;
      done
      local slot=$(getprop ro.boot.slot_suffix 2>/dev/null)
      mount -o ro -t auto /dev/block/mapper/system$slot $ANDROID_ROOT 2>/dev/null;
      mount -o rw,remount -t auto /dev/block/mapper/system$slot $ANDROID_ROOT
      if [ "$device_vendorpartition" == "true" ]; then
        mount -o ro -t auto /dev/block/mapper/vendor$slot $VENDOR 2>/dev/null;
        mount -o rw,remount -t auto /dev/block/mapper/vendor$slot $VENDOR
      fi;
      if [ -n "$(cat $fstab | grep /product)" ]; then
        mount -o ro -t auto /dev/block/mapper/product$slot /product 2>/dev/null;
        mount -o rw,remount -t auto /dev/block/mapper/product$slot /product
      fi;
      if [ -n "$(cat $fstab | grep /system_ext)" ]; then
        mount -o ro -t auto /dev/block/mapper/system_ext /system_ext 2>/dev/null;
        mount -o rw,remount -t auto /dev/block/mapper/system_ext /system_ext
      fi;
    else
      for block in system system_ext product vendor; do
        blockdev --setrw /dev/block/mapper/$block 2>/dev/null
      done
      mount -o ro -t auto /dev/block/mapper/system $ANDROID_ROOT 2>/dev/null;
      mount -o rw,remount -t auto /dev/block/mapper/system $ANDROID_ROOT
      if [ "$device_vendorpartition" == "true" ]; then
        mount -o ro -t auto /dev/block/mapper/vendor $VENDOR 2>/dev/null;
        mount -o rw,remount -t auto /dev/block/mapper/vendor $VENDOR
      fi;
      if [ -n "$(cat $fstab | grep /product)" ]; then
        mount -o ro -t auto /dev/block/mapper/product /product 2>/dev/null;
        mount -o rw,remount -t auto /dev/block/mapper/product /product
      fi;
      if [ -n "$(cat $fstab | grep /system_ext)" ]; then
        mount -o ro -t auto /dev/block/mapper/system_ext /system_ext 2>/dev/null;
        mount -o rw,remount -t auto /dev/block/mapper/system_ext /system_ext
      fi;
    fi;
  else
    if [ -d /system_root ] && [ -n "$(cat $fstab | grep /system_root)" ]; then
      local ANDROID_ROOT="/system_root";
    else
      local ANDROID_ROOT="/system";
    fi;
    mount -o ro -t auto $ANDROID_ROOT 2>/dev/null;
    mount -o rw,remount -t auto $ANDROID_ROOT
    if [ "$system_as_root" == "true" ]; then
      if [ "$device_abpartition" == "true" ]; then
        local slot=$(getprop ro.boot.slot_suffix 2>/dev/null)
        umount $ANDROID_ROOT
        if [ "$ANDROID_ROOT" == "/system_root" ] && [ -n "$(cat $fstab | grep /system_root)" ]; then
          mount -o ro -t auto /dev/block/bootdevice/by-name/system$slot /system_root 2>/dev/null;
          mount -o rw,remount -t auto /dev/block/bootdevice/by-name/system$slot /system_root
        fi;
        if [ "$ANDROID_ROOT" == "/system" ] && [ -n "$(cat $fstab | grep /system_root)" ]; then
          mount -o ro -t auto /dev/block/bootdevice/by-name/system$slot /system_root 2>/dev/null;
          mount -o rw,remount -t auto /dev/block/bootdevice/by-name/system$slot /system_root
        fi;
        if [ "$ANDROID_ROOT" == "/system" ] && [ -n "$(cat $fstab | grep /system)" ]; then
          mount -o ro -t auto /dev/block/bootdevice/by-name/system$slot /system 2>/dev/null;
          mount -o rw,remount -t auto /dev/block/bootdevice/by-name/system$slot /system
        fi;
      fi;
    fi;
    if [ "$device_vendorpartition" == "true" ]; then
      mount -o ro -t auto $VENDOR 2>/dev/null;
      mount -o rw,remount -t auto $VENDOR
      if [ "$system_as_root" == "true" ]; then
        if [ "$device_abpartition" == "true" ]; then
          local slot=$(getprop ro.boot.slot_suffix 2>/dev/null)
          umount $VENDOR
          mount -o ro -t auto /dev/block/bootdevice/by-name/vendor$slot $VENDOR 2>/dev/null;
          mount -o rw,remount -t auto /dev/block/bootdevice/by-name/vendor$slot $VENDOR
        fi;
      fi;
    fi;
    if [ -d /product ] && [ -n "$(cat $fstab | grep /product)" ]; then
      mount -o ro -t auto /product 2>/dev/null;
      mount -o rw,remount -t auto /product
      if [ "$system_as_root" == "true" ]; then
        if [ "$device_abpartition" == "true" ]; then
          local slot=$(getprop ro.boot.slot_suffix 2>/dev/null)
          umount /product
          mount -o ro -t auto /dev/block/bootdevice/by-name/product$slot /product 2>/dev/null;
          mount -o rw,remount -t auto /dev/block/bootdevice/by-name/product$slot /product
        fi;
      fi;
    fi;
  fi;
}

# Export our own system layout
system_layout() {
  if [ "$dynamic_partitions" == "true" ]; then
    S="$ANDROID_ROOT/system";
  else
    if [ -f /system_root/system/build.prop ] && [ -n "$(cat $fstab | grep /system_root)" ]; then
      S="/system_root/system";
    elif [ -f /system/system/build.prop ] && [ -n "$(cat $fstab | grep /system)" ]; then
      S="/system/system";
    elif [ "$device_abpartition" == "true" ]; then
      S="/system/system";
    elif [ "$device_abpartition" == "true" ] && [ -n "$(cat $fstab | grep /system_root)" ]; then
      S="/system_root/system";
    elif [ "$device_abpartition" == "true" ] && [ -n "$(cat $fstab | grep /system)" ]; then
      S="/system/system";
    elif [ -f /system/build.prop ] && [ -n "$(cat $fstab | grep /system_root)" ]; then
      S="/system";
    elif [ -f /system/build.prop ] && [ -n "$(cat $fstab | grep /system)" ]; then
      S="/system";
    else
      S="/system";
    fi;
  fi;
}

get_file_prop() {
  grep -m1 "^$2=" "$1" | cut -d= -f2
}

get_prop() {
  #check known .prop files using get_file_prop
  for f in $S/build.prop $S/config.prop $TMP/config.prop; do
    if [ -e "$f" ]; then
      prop="$(get_file_prop "$f" "$1")"
      if [ -n "$prop" ]; then
        break #if an entry has been found, break out of the loop
      fi;
    fi;
  done
  #if prop is still empty; try to use recovery's built-in getprop method; otherwise output current result
  if [ -z "$prop" ]; then
    getprop "$1" | cut -c1-
  else
    printf "$prop"
  fi;
}

on_version_check() {
  android_sdk="$(get_prop "ro.build.version.sdk")";
}

ensure_dir() {
  SYSTEM_APP="$SYSTEM/app";
  SYSTEM_PRIV_APP="$SYSTEM/priv-app";
  SYSTEM_ETC_DIR="$SYSTEM/etc";
  SYSTEM_ETC_CONFIG="$SYSTEM/etc/sysconfig";
  SYSTEM_ETC_DEFAULT="$SYSTEM/etc/default-permissions";
  SYSTEM_ETC_PERM="$SYSTEM/etc/permissions";
  SYSTEM_ETC_PREF="$SYSTEM/etc/preferred-apps";
  SYSTEM_FRAMEWORK="$SYSTEM/framework";
  SYSTEM_LIB="$SYSTEM/lib";
  SYSTEM_LIB64="$SYSTEM/lib64";
  SYSTEM_XBIN="$S/xbin";
  test -d $SYSTEM_APP || mkdir $SYSTEM_APP;
  test -d $SYSTEM_PRIV_APP || mkdir $SYSTEM_PRIV_APP;
  test -d $SYSTEM_ETC_DIR || mkdir $SYSTEM_ETC_DIR;
  test -d $SYSTEM_ETC_CONFIG || mkdir $SYSTEM_ETC_CONFIG;
  test -d $SYSTEM_ETC_DEFAULT || mkdir $SYSTEM_ETC_DEFAULT;
  test -d $SYSTEM_ETC_PERM || mkdir $SYSTEM_ETC_PERM;
  test -d $SYSTEM_ETC_PREF || mkdir $SYSTEM_ETC_PREF;
  test -d $SYSTEM_FRAMEWORK || mkdir $SYSTEM_FRAMEWORK;
  test -d $SYSTEM_LIB || mkdir $SYSTEM_LIB;
  test -d $SYSTEM_LIB64 || mkdir $SYSTEM_LIB64;
  test -d $SYSTEM_XBIN || mkdir $SYSTEM_XBIN;
  chmod 0755 $SYSTEM_APP
  chmod 0755 $SYSTEM_PRIV_APP
  chmod 0755 $SYSTEM_ETC_DIR
  chmod 0755 $SYSTEM_ETC_CONFIG
  chmod 0755 $SYSTEM_ETC_DEFAULT
  chmod 0755 $SYSTEM_ETC_PERM
  chmod 0755 $SYSTEM_ETC_PREF
  chmod 0755 $SYSTEM_FRAMEWORK
  chmod 0755 $SYSTEM_LIB
  chmod 0755 $SYSTEM_LIB64
  chmod 0755 $SYSTEM_XBIN
  chcon -h u:object_r:system_file:s0 "$SYSTEM_APP";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_PRIV_APP";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_DIR";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_CONFIG";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_PERM";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_DEFAULT";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_ETC_PREF";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_FRAMEWORK";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_LIB64";
  chcon -h u:object_r:system_file:s0 "$SYSTEM_XBIN";
}

# Set installation layout
set_pathmap() {
  if [ "$android_sdk" == "$supported_sdk_v30" ]; then
    SYSTEM="$S/system_ext"
    ensure_dir;
  elif [ "$android_sdk" == "$supported_sdk_v29" ]; then
    SYSTEM="$S/product"
    ensure_dir;
  else
    SYSTEM="$S"
    ensure_dir;
  fi;
}

conf_addon_backup() {
  if [ ! -f $S/config.prop ]; then
    ui_print "BackupTools: Failed to create BiTGApps backup";
  fi;
}

# Delete existing GMS Doze entry from all XML files
# This function should be executed at 'pre-restore' stage
opt_v29() {
  if [ "$android_sdk" == "$supported_sdk_v29" ]; then
    sed -i '/allow-in-power-save package="com.google.android.gms"/d' $S/etc/permissions/*.xml
    sed -i '/allow-in-power-save package="com.google.android.gms"/d' $S/etc/sysconfig/*.xml
  fi;
}

# Delete existing GMS Doze entry from all XML files
# This function should be executed at 'pre-restore' stage
opt_v30() {
  if [ "$android_sdk" == "$supported_sdk_v30" ]; then
    sed -i '/allow-in-power-save package="com.google.android.gms"/d' $S/etc/permissions/*.xml
    sed -i '/allow-in-power-save package="com.google.android.gms"/d' $S/etc/sysconfig/*.xml
  fi;
}

# Set privileged app Whitelist property
on_whitelist_check() {
  android_flag="$(get_prop "ro.control_privapp_permissions")";
  supported_flag_enforce="enforce";
  supported_flag_disable="disable";
  supported_flag_log="log";
  PROPFLAG="ro.control_privapp_permissions";
}

# Remove Privileged App Whitelist property with flag enforce
purge_whitelist_permission() {
  if [ -n "$(cat $S/build.prop | grep control_privapp_permissions)" ]; then
    grep -v "$PROPFLAG" $S/build.prop > $TMP/build.prop
    rm -rf $S/build.prop
    cp -f $TMP/build.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/build.prop
  fi;
  if [ -f "$S/product/build.prop" ]; then
    if [ -n "$(cat $S/product/build.prop | grep control_privapp_permissions)" ]; then
      mkdir $TMP/product
      grep -v "$PROPFLAG" $S/product/build.prop > $TMP/product/build.prop
      rm -rf $S/product/build.prop
      cp -f $TMP/product/build.prop $S/product/build.prop
      chmod 0644 $S/product/build.prop
      rm -rf $TMP/product/build.prop
    fi;
  fi;
  if [ -f "$S/system_ext/build.prop" ]; then
    if [ -n "$(cat $S/system_ext/build.prop | grep control_privapp_permissions)" ]; then
      mkdir $TMP/system_ext
      grep -v "$PROPFLAG" $S/system_ext/build.prop > $TMP/system_ext/build.prop
      rm -rf $S/system_ext/build.prop
      cp -f $TMP/system_ext/build.prop $S/system_ext/build.prop
      chmod 0644 $S/system_ext/build.prop
      rm -rf $TMP/system_ext/build.prop
    fi;
  fi;
  if [ -f $S/etc/prop.default ]; then
    if [ -n "$(cat $S/etc/prop.default | grep control_privapp_permissions)" ]; then
      if [ -f "$ANDROID_ROOT/default.prop" ]; then
        SYMLINK="true";
      else
        SYMLINK="false";
      fi;
      grep -v "$PROPFLAG" $S/etc/prop.default > $TMP/prop.default
      rm -rf $S/etc/prop.default
      if [ "$SYMLINK" == "true" ]; then
        rm -rf $ANDROID_ROOT/default.prop
      fi;
      cp -f $TMP/prop.default $S/etc/prop.default
      chmod 0644 $S/etc/prop.default
      if [ "$SYMLINK" == "true" ]; then
        ln -sfnv $S/etc/prop.default $ANDROID_ROOT/default.prop
      fi;
      rm -rf $TMP/prop.default
    fi;
  fi;
  if [ "$device_vendorpartition" == "true" ]; then
    if [ -n "$(cat $VENDOR/build.prop | grep control_privapp_permissions)" ]; then
      grep -v "$PROPFLAG" $VENDOR/build.prop > $TMP/build.prop
      rm -rf $VENDOR/build.prop
      cp -f $TMP/build.prop $VENDOR/build.prop
      chmod 0644 $VENDOR/build.prop
      rm -rf $TMP/build.prop
    fi;
    if [ -n "$(cat $VENDOR/default.prop | grep control_privapp_permissions)" ]; then
      grep -v "$PROPFLAG" $VENDOR/default.prop > $TMP/default.prop
      rm -rf $VENDOR/default.prop
      cp -f $TMP/default.prop $VENDOR/default.prop
      chmod 0644 $VENDOR/default.prop
      rm -rf $TMP/default.prop
    fi;
  fi;
}

# Add Whitelist property with flag disable in system
set_whitelist_permission() {
  insert_line $S/build.prop "ro.control_privapp_permissions=disable" after 'net.bt.name=Android' 'ro.control_privapp_permissions=disable';
}

# Enable Google Assistant
set_assistant() {
  insert_line $S/build.prop "ro.opa.eligible_device=true" after 'net.bt.name=Android' 'ro.opa.eligible_device=true';
}

# Check SetupWizard install status
on_setup_status_check() {
  setup_install_status="$(get_prop "ro.setup.install_status")";
}

# Check Addon install status
on_addon_status_check() {
  addon_install_status="$(get_prop "ro.addon.install_status")";
}

# Check CTS status
on_cts_status_check() {
  cts_patch_status="$(get_prop "ro.cts.patch_status")";
}

# Check RWG status
on_rwg_status_check() {
  rwg_install_status="$(get_prop "ro.rwg.device")";
}

# Apply safetynet patch
cts_patch_system() {
  # Ext Build fingerprint
  if [ -n "$(cat $S/build.prop | grep ro.system.build.fingerprint)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_EXT_BUILD_FINGERPRINT" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_EXT_BUILD_FINGERPRINT" after 'ro.system.build.date.utc=' "$CTS_SYSTEM_EXT_BUILD_FINGERPRINT";
  fi;
  # Ext Build id
  if [ -n "$(cat $S/build.prop | grep ro.system.build.id)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_EXT_BUILD_ID" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_EXT_BUILD_ID" after 'ro.system.build.fingerprint=' "$CTS_SYSTEM_EXT_BUILD_ID";
  fi;
  # Ext Build tags
  if [ -n "$(cat $S/build.prop | grep ro.system.build.tags)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_EXT_BUILD_TAG" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_EXT_BUILD_TAG" after 'ro.system.build.id=' "$CTS_SYSTEM_EXT_BUILD_TAG";
  fi;
  # Ext Build type
  if [ -n "$(cat $S/build.prop | grep ro.system.build.type)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_EXT_BUILD_TYPE" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_EXT_BUILD_TYPE" after 'ro.system.build.tags=' "$CTS_SYSTEM_EXT_BUILD_TYPE";
  fi;
  # Build fingerprint
  if [ -n "$(cat $S/build.prop | grep ro.build.fingerprint)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_BUILD_FINGERPRINT" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_BUILD_FINGERPRINT" after 'ro.build.description=' "$CTS_SYSTEM_BUILD_FINGERPRINT";
  fi;
  # Build security patch
  if [ -n "$(cat $S/build.prop | grep ro.build.version.security_patch)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_BUILD_SEC_PATCH" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_BUILD_SEC_PATCH" after 'ro.build.version.release=' "$CTS_SYSTEM_BUILD_SEC_PATCH";
  fi;
  # Build type
  if [ -n "$(cat $S/build.prop | grep ro.build.type=userdebug)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_BUILD_TYPE" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_BUILD_TYPE" after 'ro.build.date.utc=' "$CTS_SYSTEM_BUILD_TYPE";
  fi;
  # Build tags
  if [ -n "$(cat $S/build.prop | grep ro.build.tags)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_BUILD_TAG" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_BUILD_TAG" after 'ro.build.host=' "$CTS_SYSTEM_BUILD_TAG";
  fi;
  # Build description
  if [ -n "$(cat $S/build.prop | grep ro.build.description)" ]; then
    grep -v "$CTS_DEFAULT_SYSTEM_BUILD_DESC" $S/build.prop > $TMP/system.prop
    rm -rf $S/build.prop
    cp -f $TMP/system.prop $S/build.prop
    chmod 0644 $S/build.prop
    rm -rf $TMP/system.prop
    insert_line $S/build.prop "$CTS_SYSTEM_BUILD_DESC" after '# Do not try to parse description or thumbprint' "$CTS_SYSTEM_BUILD_DESC";
  fi;
}

cts_patch_product() {
  if [ -f "$S/product/build.prop" ]; then
    # Build fingerprint
    if [ -n "$(cat $S/product/build.prop | grep ro.product.build.fingerprint)" ]; then
      grep -v "$CTS_DEFAULT_PRODUCT_BUILD_FINGERPRINT" $S/product/build.prop > $TMP/product.prop
      rm -rf $S/product/build.prop
      cp -f $TMP/product.prop $S/product/build.prop
      chmod 0644 $S/product/build.prop
      rm -rf $TMP/product.prop
      insert_line $S/product/build.prop "$CTS_PRODUCT_BUILD_FINGERPRINT" after 'ro.product.build.date.utc=' "$CTS_PRODUCT_BUILD_FINGERPRINT";
    fi;
    # Build id
    if [ -n "$(cat $S/product/build.prop | grep ro.product.build.id)" ]; then
      grep -v "$CTS_DEFAULT_PRODUCT_BUILD_ID" $S/product/build.prop > $TMP/product.prop
      rm -rf $S/product/build.prop
      cp -f $TMP/product.prop $S/product/build.prop
      chmod 0644 $S/product/build.prop
      rm -rf $TMP/product.prop
      insert_line $S/product/build.prop "$CTS_PRODUCT_BUILD_ID" after 'ro.product.build.fingerprint=' "$CTS_PRODUCT_BUILD_ID";
    fi;
    # Build tags
    if [ -n "$(cat $S/product/build.prop | grep ro.product.build.tags)" ]; then
      grep -v "$CTS_DEFAULT_PRODUCT_BUILD_TAG" $S/product/build.prop > $TMP/product.prop
      rm -rf $S/product/build.prop
      cp -f $TMP/product.prop $S/product/build.prop
      chmod 0644 $S/product/build.prop
      rm -rf $TMP/product.prop
      insert_line $S/product/build.prop "$CTS_PRODUCT_BUILD_TAG" after 'ro.product.build.id=' "$CTS_PRODUCT_BUILD_TAG";
    fi;
    # Build type
    if [ -n "$(cat $S/product/build.prop | grep ro.product.build.type=userdebug)" ]; then
      grep -v "$CTS_DEFAULT_PRODUCT_BUILD_TYPE" $S/product/build.prop > $TMP/product.prop
      rm -rf $S/product/build.prop
      cp -f $TMP/product.prop $S/product/build.prop
      chmod 0644 $S/product/build.prop
      rm -rf $TMP/product.prop
      insert_line $S/product/build.prop "$CTS_PRODUCT_BUILD_TYPE" after 'ro.product.build.tags=' "$CTS_PRODUCT_BUILD_TYPE";
    fi;
  fi;
}

cts_patch_ext() {
  if [ -f "$S/system_ext/build.prop" ]; then
    # Build fingerprint
    if [ -n "$(cat $S/system_ext/build.prop | grep ro.system_ext.build.fingerprint)" ]; then
      grep -v "$CTS_DEFAULT_EXT_BUILD_FINGERPRINT" $S/system_ext/build.prop > $TMP/ext.prop
      rm -rf $S/system_ext/build.prop
      cp -f $TMP/ext.prop $S/system_ext/build.prop
      chmod 0644 $S/system_ext/build.prop
      rm -rf $TMP/ext.prop
      insert_line $S/system_ext/build.prop "$CTS_EXT_BUILD_FINGERPRINT" after 'ro.system_ext.build.date.utc=' "$CTS_EXT_BUILD_FINGERPRINT";
    fi;
    # Build id
    if [ -n "$(cat $S/system_ext/build.prop | grep ro.system_ext.build.id)" ]; then
      grep -v "$CTS_DEFAULT_EXT_BUILD_ID" $S/system_ext/build.prop > $TMP/ext.prop
      rm -rf $S/system_ext/build.prop
      cp -f $TMP/ext.prop $S/system_ext/build.prop
      chmod 0644 $S/system_ext/build.prop
      rm -rf $TMP/ext.prop
      insert_line $S/system_ext/build.prop "$CTS_EXT_BUILD_ID" after 'ro.system_ext.build.fingerprint=' "$CTS_EXT_BUILD_ID";
    fi;
    # Build tags
    if [ -n "$(cat $S/system_ext/build.prop | grep ro.system_ext.build.tags)" ]; then
      grep -v "$CTS_DEFAULT_EXT_BUILD_TAG" $S/system_ext/build.prop > $TMP/ext.prop
      rm -rf $S/system_ext/build.prop
      cp -f $TMP/ext.prop $S/system_ext/build.prop
      chmod 0644 $S/system_ext/build.prop
      rm -rf $TMP/ext.prop
      insert_line $S/system_ext/build.prop "$CTS_EXT_BUILD_TAG" after 'ro.system_ext.build.id=' "$CTS_EXT_BUILD_TAG";
    fi;
    # Build type
    if [ -n "$(cat $S/system_ext/build.prop | grep ro.system_ext.build.type=userdebug)" ]; then
      grep -v "$CTS_DEFAULT_EXT_BUILD_TYPE" $S/system_ext/build.prop > $TMP/ext.prop
      rm -rf $S/system_ext/build.prop
      cp -f $TMP/ext.prop $S/system_ext/build.prop
      chmod 0644 $S/system_ext/build.prop
      rm -rf $TMP/ext.prop
      insert_line $S/system_ext/build.prop "$CTS_EXT_BUILD_TYPE" after 'ro.system_ext.build.tags=' "$CTS_EXT_BUILD_TYPE";
    fi;
  fi;
}

# Apply safetynet patch
cts_patch_vendor() {
  if [ "$device_vendorpartition" == "true" ]; then
    # Build security patch
    if [ -n "$(cat $VENDOR/build.prop | grep ro.vendor.build.security_patch)" ]; then
      grep -v "$CTS_DEFAULT_VENDOR_BUILD_SEC_PATCH" $VENDOR/build.prop > $TMP/vendor.prop
      rm -rf $VENDOR/build.prop
      cp -f $TMP/vendor.prop $VENDOR/build.prop
      chmod 0644 $VENDOR/build.prop
      rm -rf $TMP/vendor.prop
      insert_line $VENDOR/build.prop "$CTS_VENDOR_BUILD_SEC_PATCH" after 'ro.product.first_api_level=' "$CTS_VENDOR_BUILD_SEC_PATCH";
    fi;
    # Ext Build fingerprint
    if [ -n "$(cat $VENDOR/build.prop | grep ro.vendor.build.fingerprint)" ]; then
      grep -v "$CTS_DEFAULT_VENDOR_EXT_BUILD_FINGERPRINT" $VENDOR/build.prop > $TMP/vendor.prop
      rm -rf $VENDOR/build.prop
      cp -f $TMP/vendor.prop $VENDOR/build.prop
      chmod 0644 $VENDOR/build.prop
      rm -rf $TMP/vendor.prop
      insert_line $VENDOR/build.prop "$CTS_VENDOR_EXT_BUILD_FINGERPRINT" after 'ro.vendor.build.date.utc=' "$CTS_VENDOR_EXT_BUILD_FINGERPRINT";
    fi;
    # Build fingerprint
    if [ -n "$(cat $VENDOR/build.prop | grep ro.build.fingerprint)" ]; then
      grep -v "$CTS_DEFAULT_VENDOR_BUILD_FINGERPRINT" $VENDOR/build.prop > $TMP/vendor.prop
      rm -rf $VENDOR/build.prop
      cp -f $TMP/vendor.prop $VENDOR/build.prop
      chmod 0644 $VENDOR/build.prop
      rm -rf $TMP/vendor.prop
      insert_line $VENDOR/build.prop "$CTS_VENDOR_BUILD_FINGERPRINT" after 'ro.vendor.build.fingerprint=' "$CTS_VENDOR_BUILD_FINGERPRINT";
    fi;
    # Build id
    if [ -n "$(cat $VENDOR/build.prop | grep ro.vendor.build.id)" ]; then
      grep -v "$CTS_DEFAULT_VENDOR_BUILD_ID" $VENDOR/build.prop > $TMP/vendor.prop
      rm -rf $VENDOR/build.prop
      cp -f $TMP/vendor.prop $VENDOR/build.prop
      chmod 0644 $VENDOR/build.prop
      rm -rf $TMP/vendor.prop
      insert_line $VENDOR/build.prop "$CTS_VENDOR_BUILD_ID" after 'ro.vendor.build.fingerprint=' "$CTS_VENDOR_BUILD_ID";
    fi;
    # Build tags
    if [ -n "$(cat $VENDOR/build.prop | grep ro.vendor.build.tags)" ]; then
      grep -v "$CTS_DEFAULT_VENDOR_BUILD_TAG" $VENDOR/build.prop > $TMP/vendor.prop
      rm -rf $VENDOR/build.prop
      cp -f $TMP/vendor.prop $VENDOR/build.prop
      chmod 0644 $VENDOR/build.prop
      rm -rf $TMP/vendor.prop
      insert_line $VENDOR/build.prop "$CTS_VENDOR_BUILD_TAG" after 'ro.vendor.build.id=' "$CTS_VENDOR_BUILD_TAG";
    fi;
    # Build type
    if [ -n "$(cat $VENDOR/build.prop | grep ro.vendor.build.type)" ]; then
      grep -v "$CTS_DEFAULT_VENDOR_BUILD_TYPE" $VENDOR/build.prop > $TMP/vendor.prop
      rm -rf $VENDOR/build.prop
      cp -f $TMP/vendor.prop $VENDOR/build.prop
      chmod 0644 $VENDOR/build.prop
      rm -rf $TMP/vendor.prop
      insert_line $VENDOR/build.prop "$CTS_VENDOR_BUILD_TYPE" after 'ro.vendor.build.tags=' "$CTS_VENDOR_BUILD_TYPE";
    fi;
    # Build bootimage
    if [ -n "$(cat $VENDOR/build.prop | grep ro.bootimage.build.fingerprint)" ]; then
      grep -v "$CTS_DEFAULT_VENDOR_BUILD_BOOTIMAGE" $VENDOR/build.prop > $TMP/vendor.prop
      rm -rf $VENDOR/build.prop
      cp -f $TMP/vendor.prop $VENDOR/build.prop
      chmod 0644 $VENDOR/build.prop
      rm -rf $TMP/vendor.prop
      insert_line $VENDOR/build.prop "$CTS_VENDOR_BUILD_BOOTIMAGE" after 'ro.bootimage.build.date.utc=' "$CTS_VENDOR_BUILD_BOOTIMAGE";
    fi;
  fi;
}

cts_patch() {
  if [ "$android_sdk" == "$supported_sdk_v30" ]; then
    if [ "$cts_patch_status" == "verified" ]; then
      patch_v30;
      cts_patch_system;
      cts_patch_product;
      cts_patch_ext;
      cts_patch_vendor;
    fi;
    if [ "$cts_patch_status" == "enforced" ]; then
      patch_v30;
      cts_patch_system;
      cts_patch_product;
      cts_patch_ext;
      cts_patch_vendor;
    fi;
  fi;
  if [ "$android_sdk" == "$supported_sdk_v29" ]; then
    if [ "$cts_patch_status" == "verified" ]; then
      patch_v29;
      cts_patch_system;
      cts_patch_product;
      cts_patch_ext;
      cts_patch_vendor;
    fi;
    if [ "$cts_patch_status" == "enforced" ]; then
      patch_v29;
      cts_patch_system;
      cts_patch_product;
      cts_patch_ext;
      cts_patch_vendor;
    fi;
  fi;
}

# API fixes
sdk_fix() {
  if [ "$android_sdk" -ge "26" ]; then # Android 8.0+ uses 0600 for its permission on build.prop
    chmod 0600 $S/build.prop
    if [ -f "$S/etc/prop.default" ]; then
      chmod 0600 $S/etc/prop.default
    fi;
    if [ -f "$S/product/build.prop" ]; then
      chmod 0600 $S/product/build.prop
    fi;
    if [ -f "$S/system_ext/build.prop" ]; then
      chmod 0600 $S/system_ext/build.prop
    fi;
    if [ "$device_vendorpartition" = "true" ]; then
      chmod 0600 $VENDOR/build.prop
      chmod 0600 $VENDOR/default.prop
    fi;
  fi;
}

# SELinux security context
selinux_fix() {
  chcon -h u:object_r:system_file:s0 "$S/build.prop";
  if [ -f $S/etc/prop.default ]; then
    chcon -h u:object_r:system_file:s0 "$S/etc/prop.default";
  fi;
  if [ -f "$S/product/build.prop" ]; then
    chcon -h u:object_r:system_file:s0 "$S/product/build.prop";
  fi;
  if [ -f "$S/system_ext/build.prop" ]; then
    chcon -h u:object_r:system_file:s0 "$S/system_ext/build.prop";
  fi;
  if [ "$device_vendorpartition" == "true" ]; then
    chcon -h u:object_r:vendor_file:s0 "$VENDOR/build.prop";
    chcon -h u:object_r:vendor_file:s0 "$VENDOR/default.prop";
  fi;
}

# Remove pre-installed packages shipped with ROM
pre_installed() {
  if [ "$rwg_install_status" == "true" ]; then
    rm -rf $S/addon.d/30*
    rm -rf $S/addon.d/50*
    rm -rf $S/addon.d/69*
    rm -rf $S/addon.d/70*
    rm -rf $S/addon.d/71*
    rm -rf $S/addon.d/74*
    rm -rf $S/addon.d/75*
    rm -rf $S/addon.d/78*
    rm -rf $S/addon.d/90*
    rm -rf $S/app/AndroidAuto*
    rm -rf $S/app/arcore
    rm -rf $S/app/Books*
    rm -rf $S/app/CarHomeGoogle
    rm -rf $S/app/CalculatorGoogle*
    rm -rf $S/app/CalendarGoogle*
    rm -rf $S/app/CarHomeGoogle
    rm -rf $S/app/Chrome*
    rm -rf $S/app/CloudPrint*
    rm -rf $S/app/DevicePersonalizationServices
    rm -rf $S/app/DMAgent
    rm -rf $S/app/Drive
    rm -rf $S/app/Duo
    rm -rf $S/app/EditorsDocs
    rm -rf $S/app/Editorssheets
    rm -rf $S/app/EditorsSlides
    rm -rf $S/app/ExchangeServices
    rm -rf $S/app/FaceLock
    rm -rf $S/app/Fitness*
    rm -rf $S/app/GalleryGo*
    rm -rf $S/app/Gcam*
    rm -rf $S/app/GCam*
    rm -rf $S/app/Gmail*
    rm -rf $S/app/GoogleCamera*
    rm -rf $S/app/GoogleCalendar*
    rm -rf $S/app/GoogleCalendarSyncAdapter
    rm -rf $S/app/GoogleContactsSyncAdapter
    rm -rf $S/app/GoogleCloudPrint
    rm -rf $S/app/GoogleEarth
    rm -rf $S/app/GoogleExtshared
    rm -rf $S/app/GooglePrintRecommendationService
    rm -rf $S/app/GoogleGo*
    rm -rf $S/app/GoogleHome*
    rm -rf $S/app/GoogleHindiIME*
    rm -rf $S/app/GoogleKeep*
    rm -rf $S/app/GoogleJapaneseInput*
    rm -rf $S/app/GoogleLoginService*
    rm -rf $S/app/GoogleMusic*
    rm -rf $S/app/GoogleNow*
    rm -rf $S/app/GooglePhotos*
    rm -rf $S/app/GooglePinyinIME*
    rm -rf $S/app/GooglePlus
    rm -rf $S/app/GoogleTTS*
    rm -rf $S/app/GoogleVrCore*
    rm -rf $S/app/GoogleZhuyinIME*
    rm -rf $S/app/Hangouts
    rm -rf $S/app/KoreanIME*
    rm -rf $S/app/Maps
    rm -rf $S/app/Markup*
    rm -rf $S/app/Music2*
    rm -rf $S/app/Newsstand
    rm -rf $S/app/NexusWallpapers*
    rm -rf $S/app/Ornament
    rm -rf $S/app/Photos*
    rm -rf $S/app/PlayAutoInstallConfig*
    rm -rf $S/app/PlayGames*
    rm -rf $S/app/PrebuiltExchange3Google
    rm -rf $S/app/PrebuiltGmail
    rm -rf $S/app/PrebuiltKeep
    rm -rf $S/app/Street
    rm -rf $S/app/Stickers*
    rm -rf $S/app/TalkBack
    rm -rf $S/app/talkBack
    rm -rf $S/app/talkback
    rm -rf $S/app/TranslatePrebuilt
    rm -rf $S/app/Tycho
    rm -rf $S/app/Videos
    rm -rf $S/app/Wallet
    rm -rf $S/app/WallpapersBReel*
    rm -rf $S/app/YouTube
    rm -rf $S/etc/default-permissions/default-permissions.xml
    rm -rf $S/etc/default-permissions/opengapps-permissions.xml
    rm -rf $S/etc/permissions/default-permissions.xml
    rm -rf $S/etc/permissions/privapp-permissions-google.xml
    rm -rf $S/etc/permissions/privapp-permissions-google*
    rm -rf $S/etc/permissions/com.android.contacts.xml
    rm -rf $S/etc/permissions/com.android.dialer.xml
    rm -rf $S/etc/permissions/com.android.managedprovisioning.xml
    rm -rf $S/etc/permissions/com.android.provision.xml
    rm -rf $S/etc/permissions/com.google.android.camera*
    rm -rf $S/etc/permissions/com.google.android.dialer*
    rm -rf $S/etc/permissions/com.google.android.maps*
    rm -rf $S/etc/permissions/split-permissions-google.xml
    rm -rf $S/etc/preferred-apps/google.xml
    rm -rf $S/etc/preferred-apps/google_build.xml
    rm -rf $S/etc/sysconfig/pixel_2017_exclusive.xml
    rm -rf $S/etc/sysconfig/pixel_experience_2017.xml
    rm -rf $S/etc/sysconfig/gmsexpress.xml
    rm -rf $S/etc/sysconfig/googledialergo-sysconfig.xml
    rm -rf $S/etc/sysconfig/google-hiddenapi-package-whitelist.xml
    rm -rf $S/etc/sysconfig/google.xml
    rm -rf $S/etc/sysconfig/google_build.xml
    rm -rf $S/etc/sysconfig/google_experience.xml
    rm -rf $S/etc/sysconfig/google_exclusives_enable.xml
    rm -rf $S/etc/sysconfig/go_experience.xml
    rm -rf $S/etc/sysconfig/nga.xml
    rm -rf $S/etc/sysconfig/nexus.xml
    rm -rf $S/etc/sysconfig/pixel*
    rm -rf $S/etc/sysconfig/turbo.xml
    rm -rf $S/etc/sysconfig/wellbeing.xml
    rm -rf $S/framework/com.google.android.camera*
    rm -rf $S/framework/com.google.android.dialer*
    rm -rf $S/framework/com.google.android.maps*
    rm -rf $S/framework/oat/arm/com.google.android.camera*
    rm -rf $S/framework/oat/arm/com.google.android.dialer*
    rm -rf $S/framework/oat/arm/com.google.android.maps*
    rm -rf $S/framework/oat/arm64/com.google.android.camera*
    rm -rf $S/framework/oat/arm64/com.google.android.dialer*
    rm -rf $S/framework/oat/arm64/com.google.android.maps*
    rm -rf $S/lib/libaiai-annotators.so
    rm -rf $S/lib/libcronet.70.0.3522.0.so
    rm -rf $S/lib/libfilterpack_facedetect.so
    rm -rf $S/lib/libfrsdk.so
    rm -rf $S/lib/libgcam.so
    rm -rf $S/lib/libgcam_swig_jni.so
    rm -rf $S/lib/libocr.so
    rm -rf $S/lib/libparticle-extractor_jni.so
    rm -rf $S/lib64/libbarhopper.so
    rm -rf $S/lib64/libfacenet.so
    rm -rf $S/lib64/libfilterpack_facedetect.so
    rm -rf $S/lib64/libfrsdk.so
    rm -rf $S/lib64/libgcam.so
    rm -rf $S/lib64/libgcam_swig_jni.so
    rm -rf $S/lib64/libsketchology_native.so
    rm -rf $S/overlay/PixelConfigOverlay*
    rm -rf $S/priv-app/Aiai*
    rm -rf $S/priv-app/AmbientSense*
    rm -rf $S/priv-app/AndroidAuto*
    rm -rf $S/priv-app/AndroidMigrate*
    rm -rf $S/priv-app/AndroidPlatformServices
    rm -rf $S/priv-app/CalendarGoogle*
    rm -rf $S/priv-app/CalculatorGoogle*
    rm -rf $S/priv-app/Camera*
    rm -rf $S/priv-app/CarrierServices
    rm -rf $S/priv-app/CarrierSetup
    rm -rf $S/priv-app/ConfigUpdater
    rm -rf $S/priv-app/DataTransferTool
    rm -rf $S/priv-app/DeviceHealthServices
    rm -rf $S/priv-app/DevicePersonalizationServices
    rm -rf $S/priv-app/DigitalWellbeing*
    rm -rf $S/priv-app/FaceLock
    rm -rf $S/priv-app/Gcam*
    rm -rf $S/priv-app/GCam*
    rm -rf $S/priv-app/GCS
    rm -rf $S/priv-app/GmsCore*
    rm -rf $S/priv-app/GoogleCalculator*
    rm -rf $S/priv-app/GoogleCalendar*
    rm -rf $S/priv-app/GoogleCamera*
    rm -rf $S/priv-app/GoogleBackupTransport
    rm -rf $S/priv-app/GoogleExtservices
    rm -rf $S/priv-app/GoogleExtServicesPrebuilt
    rm -rf $S/priv-app/GoogleFeedback
    rm -rf $S/priv-app/GoogleOneTimeInitializer
    rm -rf $S/priv-app/GooglePartnerSetup
    rm -rf $S/priv-app/GoogleRestore
    rm -rf $S/priv-app/GoogleServicesFramework
    rm -rf $S/priv-app/HotwordEnrollment*
    rm -rf $S/priv-app/HotWordEnrollment*
    rm -rf $S/priv-app/matchmaker*
    rm -rf $S/priv-app/Matchmaker*
    rm -rf $S/priv-app/Phonesky
    rm -rf $S/priv-app/PixelLive*
    rm -rf $S/priv-app/PrebuiltGmsCore*
    rm -rf $S/priv-app/PixelSetupWizard*
    rm -rf $S/priv-app/SetupWizard*
    rm -rf $S/priv-app/Tag*
    rm -rf $S/priv-app/Tips*
    rm -rf $S/priv-app/Turbo*
    rm -rf $S/priv-app/Velvet
    rm -rf $S/priv-app/Wellbeing*
    rm -rf $S/usr/srec/en-US
    rm -rf $S/product/app/AndroidAuto*
    rm -rf $S/product/app/arcore
    rm -rf $S/product/app/Books*
    rm -rf $S/product/app/CalculatorGoogle*
    rm -rf $S/product/app/CalendarGoogle*
    rm -rf $S/product/app/CarHomeGoogle
    rm -rf $S/product/app/Chrome*
    rm -rf $S/product/app/CloudPrint*
    rm -rf $S/product/app/DMAgent
    rm -rf $S/product/app/DevicePersonalizationServices
    rm -rf $S/product/app/Drive
    rm -rf $S/product/app/Duo
    rm -rf $S/product/app/EditorsDocs
    rm -rf $S/product/app/Editorssheets
    rm -rf $S/product/app/EditorsSlides
    rm -rf $S/product/app/ExchangeServices
    rm -rf $S/product/app/FaceLock
    rm -rf $S/product/app/Fitness*
    rm -rf $S/product/app/GalleryGo*
    rm -rf $S/product/app/Gcam*
    rm -rf $S/product/app/GCam*
    rm -rf $S/product/app/Gmail*
    rm -rf $S/product/app/GoogleCamera*
    rm -rf $S/product/app/GoogleCalendar*
    rm -rf $S/product/app/GoogleContacts*
    rm -rf $S/product/app/GoogleCloudPrint
    rm -rf $S/product/app/GoogleEarth
    rm -rf $S/product/app/GoogleExtshared
    rm -rf $S/product/app/GoogleExtShared
    rm -rf $S/product/app/GoogleGalleryGo
    rm -rf $S/product/app/GoogleGo*
    rm -rf $S/product/app/GoogleHome*
    rm -rf $S/product/app/GoogleHindiIME*
    rm -rf $S/product/app/GoogleKeep*
    rm -rf $S/product/app/GoogleJapaneseInput*
    rm -rf $S/product/app/GoogleLoginService*
    rm -rf $S/product/app/GoogleMusic*
    rm -rf $S/product/app/GoogleNow*
    rm -rf $S/product/app/GooglePhotos*
    rm -rf $S/product/app/GooglePinyinIME*
    rm -rf $S/product/app/GooglePlus
    rm -rf $S/product/app/GoogleTTS*
    rm -rf $S/product/app/GoogleVrCore*
    rm -rf $S/product/app/GoogleZhuyinIME*
    rm -rf $S/product/app/Hangouts
    rm -rf $S/product/app/KoreanIME*
    rm -rf $S/product/app/LocationHistory*
    rm -rf $S/product/app/Maps
    rm -rf $S/product/app/Markup*
    rm -rf $S/product/app/MicropaperPrebuilt
    rm -rf $S/product/app/Music2*
    rm -rf $S/product/app/Newsstand
    rm -rf $S/product/app/NexusWallpapers*
    rm -rf $S/product/app/Ornament
    rm -rf $S/product/app/Photos*
    rm -rf $S/product/app/PlayAutoInstallConfig*
    rm -rf $S/product/app/PlayGames*
    rm -rf $S/product/app/PrebuiltBugle
    rm -rf $S/product/app/PrebuiltClockGoogle
    rm -rf $S/product/app/PrebuiltDeskClockGoogle
    rm -rf $S/product/app/PrebuiltExchange3Google
    rm -rf $S/product/app/PrebuiltGmail
    rm -rf $S/product/app/PrebuiltKeep
    rm -rf $S/product/app/SoundAmplifierPrebuilt
    rm -rf $S/product/app/Street
    rm -rf $S/product/app/Stickers*
    rm -rf $S/product/app/TalkBack
    rm -rf $S/product/app/talkBack
    rm -rf $S/product/app/talkback
    rm -rf $S/product/app/TranslatePrebuilt
    rm -rf $S/product/app/Tycho
    rm -rf $S/product/app/Videos
    rm -rf $S/product/app/Wallet
    rm -rf $S/product/app/WallpapersBReel*
    rm -rf $S/product/app/YouTube*
    rm -rf $S/product/etc/default-permissions/default-permissions.xml
    rm -rf $S/product/etc/default-permissions/opengapps-permissions.xml
    rm -rf $S/product/etc/permissions/default-permissions.xml
    rm -rf $S/product/etc/permissions/privapp-permissions-google.xml
    rm -rf $S/product/etc/permissions/privapp-permissions-google*
    rm -rf $S/product/etc/permissions/com.android.contacts.xml
    rm -rf $S/product/etc/permissions/com.android.dialer.xml
    rm -rf $S/product/etc/permissions/com.android.managedprovisioning.xml
    rm -rf $S/product/etc/permissions/com.android.provision.xml
    rm -rf $S/product/etc/permissions/com.google.android.camera*
    rm -rf $S/product/etc/permissions/com.google.android.dialer*
    rm -rf $S/product/etc/permissions/com.google.android.maps*
    rm -rf $S/product/etc/permissions/split-permissions-google.xml
    rm -rf $S/product/etc/preferred-apps/google.xml
    rm -rf $S/product/etc/preferred-apps/google_build.xml
    rm -rf $S/product/etc/sysconfig/pixel_2017_exclusive.xml
    rm -rf $S/product/etc/sysconfig/pixel_experience_2017.xml
    rm -rf $S/product/etc/sysconfig/gmsexpress.xml
    rm -rf $S/product/etc/sysconfig/googledialergo-sysconfig.xml
    rm -rf $S/product/etc/sysconfig/google-hiddenapi-package-whitelist.xml
    rm -rf $S/product/etc/sysconfig/google.xml
    rm -rf $S/product/etc/sysconfig/google_build.xml
    rm -rf $S/product/etc/sysconfig/google_experience.xml
    rm -rf $S/product/etc/sysconfig/google_exclusives_enable.xml
    rm -rf $S/product/etc/sysconfig/go_experience.xml
    rm -rf $S/product/etc/sysconfig/nexus.xml
    rm -rf $S/product/etc/sysconfig/nga.xml
    rm -rf $S/product/etc/sysconfig/pixel*
    rm -rf $S/product/etc/sysconfig/turbo.xml
    rm -rf $S/product/etc/sysconfig/wellbeing.xml
    rm -rf $S/product/framework/com.google.android.camera*
    rm -rf $S/product/framework/com.google.android.dialer*
    rm -rf $S/product/framework/com.google.android.maps*
    rm -rf $S/product/framework/oat/arm/com.google.android.camera*
    rm -rf $S/product/framework/oat/arm/com.google.android.dialer*
    rm -rf $S/product/framework/oat/arm/com.google.android.maps*
    rm -rf $S/product/framework/oat/arm64/com.google.android.camera*
    rm -rf $S/product/framework/oat/arm64/com.google.android.dialer*
    rm -rf $S/product/framework/oat/arm64/com.google.android.maps*
    rm -rf $S/product/lib/libaiai-annotators.so
    rm -rf $S/product/lib/libcronet.70.0.3522.0.so
    rm -rf $S/product/lib/libfilterpack_facedetect.so
    rm -rf $S/product/lib/libfrsdk.so
    rm -rf $S/product/lib/libgcam.so
    rm -rf $S/product/lib/libgcam_swig_jni.so
    rm -rf $S/product/lib/libocr.so
    rm -rf $S/product/lib/libparticle-extractor_jni.so
    rm -rf $S/product/lib64/libbarhopper.so
    rm -rf $S/product/lib64/libfacenet.so
    rm -rf $S/product/lib64/libfilterpack_facedetect.so
    rm -rf $S/product/lib64/libfrsdk.so
    rm -rf $S/product/lib64/libgcam.so
    rm -rf $S/product/lib64/libgcam_swig_jni.so
    rm -rf $S/product/lib64/libsketchology_native.so
    rm -rf $S/product/overlay/GoogleConfigOverlay*
    rm -rf $S/product/overlay/PixelConfigOverlay*
    rm -rf $S/product/overlay/Gms*
    rm -rf $S/product/priv-app/Aiai*
    rm -rf $S/product/priv-app/AmbientSense*
    rm -rf $S/product/priv-app/AndroidAuto*
    rm -rf $S/product/priv-app/AndroidMigrate*
    rm -rf $S/product/priv-app/AndroidPlatformServices
    rm -rf $S/product/priv-app/CalendarGoogle*
    rm -rf $S/product/priv-app/CalculatorGoogle*
    rm -rf $S/product/priv-app/Camera*
    rm -rf $S/product/priv-app/CarrierServices
    rm -rf $S/product/priv-app/CarrierSetup
    rm -rf $S/product/priv-app/ConfigUpdater
    rm -rf $S/product/priv-app/ConnMetrics
    rm -rf $S/product/priv-app/DataTransferTool
    rm -rf $S/product/priv-app/DeviceHealthServices
    rm -rf $S/product/priv-app/DevicePersonalizationServices
    rm -rf $S/product/priv-app/DigitalWellbeing*
    rm -rf $S/product/priv-app/FaceLock
    rm -rf $S/product/priv-app/Gcam*
    rm -rf $S/product/priv-app/GCam*
    rm -rf $S/product/priv-app/GCS
    rm -rf $S/product/priv-app/GmsCore*
    rm -rf $S/product/priv-app/GoogleBackupTransport
    rm -rf $S/product/priv-app/GoogleCalculator*
    rm -rf $S/product/priv-app/GoogleCalendar*
    rm -rf $S/product/priv-app/GoogleCamera*
    rm -rf $S/product/priv-app/GoogleContacts*
    rm -rf $S/product/priv-app/GoogleDialer
    rm -rf $S/product/priv-app/GoogleExtservices
    rm -rf $S/product/priv-app/GoogleExtServices
    rm -rf $S/product/priv-app/GoogleFeedback
    rm -rf $S/product/priv-app/GoogleOneTimeInitializer
    rm -rf $S/product/priv-app/GooglePartnerSetup
    rm -rf $S/product/priv-app/GoogleRestore
    rm -rf $S/product/priv-app/GoogleServicesFramework
    rm -rf $S/product/priv-app/HotwordEnrollment*
    rm -rf $S/product/priv-app/HotWordEnrollment*
    rm -rf $S/product/priv-app/MaestroPrebuilt
    rm -rf $S/product/priv-app/matchmaker*
    rm -rf $S/product/priv-app/Matchmaker*
    rm -rf $S/product/priv-app/Phonesky
    rm -rf $S/product/priv-app/PixelLive*
    rm -rf $S/product/priv-app/PrebuiltGmsCore*
    rm -rf $S/product/priv-app/PixelSetupWizard*
    rm -rf $S/product/priv-app/RecorderPrebuilt
    rm -rf $S/product/priv-app/SCONE
    rm -rf $S/product/priv-app/Scribe*
    rm -rf $S/product/priv-app/SetupWizard*
    rm -rf $S/product/priv-app/Tag*
    rm -rf $S/product/priv-app/Tips*
    rm -rf $S/product/priv-app/Turbo*
    rm -rf $S/product/priv-app/Velvet
    rm -rf $S/product/priv-app/WallpaperPickerGoogleRelease
    rm -rf $S/product/priv-app/Wellbeing*
    rm -rf $S/product/usr/srec/en-US
    rm -rf $S/app/Abstruct
    rm -rf $S/app/BasicDreams
    rm -rf $S/app/BlissPapers
    rm -rf $S/app/BookmarkProvider
    rm -rf $S/app/Browser*
    rm -rf $S/app/Camera*
    rm -rf $S/app/Chromium
    rm -rf $S/app/ColtPapers
    rm -rf $S/app/EasterEgg*
    rm -rf $S/app/EggGame
    rm -rf $S/app/Email*
    rm -rf $S/app/ExactCalculator
    rm -rf $S/app/Exchange2
    rm -rf $S/app/Gallery*
    rm -rf $S/app/GugelClock
    rm -rf $S/app/HTMLViewer
    rm -rf $S/app/Jelly
    rm -rf $S/app/messaging
    rm -rf $S/app/MiXplorer*
    rm -rf $S/app/Music*
    rm -rf $S/app/Partnerbookmark*
    rm -rf $S/app/PartnerBookmark*
    rm -rf $S/app/Phonograph
    rm -rf $S/app/PhotoTable
    rm -rf $S/app/RetroMusic*
    rm -rf $S/app/VanillaMusic
    rm -rf $S/app/Via*
    rm -rf $S/app/QPGallery
    rm -rf $S/app/QuickSearchBox
    rm -rf $S/priv-app/AudioFX
    rm -rf $S/priv-app/Camera*
    rm -rf $S/priv-app/Eleven
    rm -rf $S/priv-app/MatLog
    rm -rf $S/priv-app/MusicFX
    rm -rf $S/priv-app/OmniSwitch
    rm -rf $S/priv-app/Snap*
    rm -rf $S/priv-app/Tag*
    rm -rf $S/priv-app/Via*
    rm -rf $S/priv-app/VinylMusicPlayer
    rm -rf $S/product/app/AboutBliss
    rm -rf $S/product/app/BasicDreams
    rm -rf $S/product/app/BlissStatistics
    rm -rf $S/product/app/BookmarkProvider
    rm -rf $S/product/app/Browser*
    rm -rf $S/product/app/Calendar*
    rm -rf $S/product/app/Camera*
    rm -rf $S/product/app/Dashboard
    rm -rf $S/product/app/DeskClock
    rm -rf $S/product/app/EasterEgg*
    rm -rf $S/product/app/Email*
    rm -rf $S/product/app/EmergencyInfo
    rm -rf $S/product/app/Etar
    rm -rf $S/product/app/Gallery*
    rm -rf $S/product/app/HTMLViewer
    rm -rf $S/product/app/Jelly
    rm -rf $S/product/app/Messaging
    rm -rf $S/product/app/messaging
    rm -rf $S/product/app/Music*
    rm -rf $S/product/app/Partnerbookmark*
    rm -rf $S/product/app/PartnerBookmark*
    rm -rf $S/product/app/PhotoTable*
    rm -rf $S/product/app/Recorder*
    rm -rf $S/product/app/RetroMusic*
    rm -rf $S/product/app/SimpleGallery
    rm -rf $S/product/app/Via*
    rm -rf $S/product/app/WallpaperZone
    rm -rf $S/product/app/QPGallery
    rm -rf $S/product/app/QuickSearchBox
    rm -rf $S/product/overlay/ChromeOverlay
    rm -rf $S/product/overlay/TelegramOverlay
    rm -rf $S/product/overlay/WhatsAppOverlay
    rm -rf $S/product/priv-app/AncientWallpaperZone
    rm -rf $S/product/priv-app/Camera*
    rm -rf $S/product/priv-app/Contacts
    rm -rf $S/product/priv-app/crDroidMusic
    rm -rf $S/product/priv-app/Dialer
    rm -rf $S/product/priv-app/Eleven
    rm -rf $S/product/priv-app/EmergencyInfo
    rm -rf $S/product/priv-app/Gallery2
    rm -rf $S/product/priv-app/MatLog
    rm -rf $S/product/priv-app/MusicFX
    rm -rf $S/product/priv-app/OmniSwitch
    rm -rf $S/product/priv-app/Recorder*
    rm -rf $S/product/priv-app/Snap*
    rm -rf $S/product/priv-app/Tag*
    rm -rf $S/product/priv-app/Via*
    rm -rf $S/product/priv-app/VinylMusicPlayer
    rm -rf $S/app/AppleNLP*
    rm -rf $S/app/AuroraDroid
    rm -rf $S/app/AuroraStore
    rm -rf $S/app/DejaVu*
    rm -rf $S/app/DroidGuard
    rm -rf $S/app/LocalGSM*
    rm -rf $S/app/LocalWiFi*
    rm -rf $S/app/MicroG*
    rm -rf $S/app/MozillaUnified*
    rm -rf $S/app/nlp*
    rm -rf $S/app/Nominatim*
    rm -rf $S/product/app/AppleNLP*
    rm -rf $S/product/app/AuroraDroid
    rm -rf $S/product/app/AuroraStore
    rm -rf $S/product/app/DejaVu*
    rm -rf $S/product/app/DroidGuard
    rm -rf $S/product/app/LocalGSM*
    rm -rf $S/product/app/LocalWiFi*
    rm -rf $S/product/app/MicroG*
    rm -rf $S/product/app/MozillaUnified*
    rm -rf $S/product/app/nlp*
    rm -rf $S/product/app/Nominatim*
    rm -rf $S/priv-app/AuroraServices
    rm -rf $S/priv-app/FakeStore
    rm -rf $S/priv-app/GmsCore
    rm -rf $S/priv-app/GsfProxy
    rm -rf $S/priv-app/MicroG*
    rm -rf $S/priv-app/PatchPhonesky
    rm -rf $S/priv-app/Phonesky
    rm -rf $S/product/priv-app/AuroraServices
    rm -rf $S/product/priv-app/FakeStore
    rm -rf $S/product/priv-app/GmsCore
    rm -rf $S/product/priv-app/GsfProxy
    rm -rf $S/product/priv-app/MicroG*
    rm -rf $S/product/priv-app/PatchPhonesky
    rm -rf $S/product/priv-app/Phonesky
    rm -rf $S/etc/default-permissions/microg*
    rm -rf $S/etc/default-permissions/phonesky*
    rm -rf $S/etc/permissions/features.xml
    rm -rf $S/etc/permissions/com.android.vending*
    rm -rf $S/etc/permissions/com.aurora.services*
    rm -rf $S/etc/permissions/com.google.android.backup*
    rm -rf $S/etc/permissions/com.google.android.gms*
    rm -rf $S/etc/sysconfig/microg*
    rm -rf $S/etc/sysconfig/nogoolag*
    rm -rf $S/product/etc/default-permissions/microg*
    rm -rf $S/product/etc/default-permissions/phonesky*
    rm -rf $S/product/etc/permissions/features.xml
    rm -rf $S/product/etc/permissions/com.android.vending*
    rm -rf $S/product/etc/permissions/com.aurora.services*
    rm -rf $S/product/etc/permissions/com.google.android.backup*
    rm -rf $S/product/etc/permissions/com.google.android.gms*
    rm -rf $S/product/etc/sysconfig/microg*
    rm -rf $S/product/etc/sysconfig/nogoolag*
    rm -rf $S/bin/nanodroid*
    rm -rf $S/bin/novl
    rm -rf $S/bin/npem
    rm -rf $S/bin/nprp
    rm -rf $S/bin/nutl
    rm -rf $S/xbin/nanodroid*
    rm -rf $S/xbin/novl
    rm -rf $S/xbin/npem
    rm -rf $S/xbin/nprp
    rm -rf $S/xbin/nutl
  fi;
}

pre_installed_ext() {
  if [ "$rwg_install_status" == "true" ]; then
    rm -rf $S/addon.d/30*
    rm -rf $S/addon.d/50*
    rm -rf $S/addon.d/69*
    rm -rf $S/addon.d/70*
    rm -rf $S/addon.d/71*
    rm -rf $S/addon.d/74*
    rm -rf $S/addon.d/75*
    rm -rf $S/addon.d/78*
    rm -rf $S/addon.d/90*
    rm -rf $S/app/AndroidAuto*
    rm -rf $S/app/arcore
    rm -rf $S/app/Books*
    rm -rf $S/app/CarHomeGoogle
    rm -rf $S/app/CalculatorGoogle*
    rm -rf $S/app/CalendarGoogle*
    rm -rf $S/app/CarHomeGoogle
    rm -rf $S/app/Chrome*
    rm -rf $S/app/CloudPrint*
    rm -rf $S/app/DevicePersonalizationServices
    rm -rf $S/app/DMAgent
    rm -rf $S/app/Drive
    rm -rf $S/app/Duo
    rm -rf $S/app/EditorsDocs
    rm -rf $S/app/Editorssheets
    rm -rf $S/app/EditorsSlides
    rm -rf $S/app/ExchangeServices
    rm -rf $S/app/FaceLock
    rm -rf $S/app/Fitness*
    rm -rf $S/app/GalleryGo*
    rm -rf $S/app/Gcam*
    rm -rf $S/app/GCam*
    rm -rf $S/app/Gmail*
    rm -rf $S/app/GoogleCamera*
    rm -rf $S/app/GoogleCalendar*
    rm -rf $S/app/GoogleCalendarSyncAdapter
    rm -rf $S/app/GoogleContactsSyncAdapter
    rm -rf $S/app/GoogleCloudPrint
    rm -rf $S/app/GoogleEarth
    rm -rf $S/app/GoogleExtshared
    rm -rf $S/app/GooglePrintRecommendationService
    rm -rf $S/app/GoogleGo*
    rm -rf $S/app/GoogleHome*
    rm -rf $S/app/GoogleHindiIME*
    rm -rf $S/app/GoogleKeep*
    rm -rf $S/app/GoogleJapaneseInput*
    rm -rf $S/app/GoogleLoginService*
    rm -rf $S/app/GoogleMusic*
    rm -rf $S/app/GoogleNow*
    rm -rf $S/app/GooglePhotos*
    rm -rf $S/app/GooglePinyinIME*
    rm -rf $S/app/GooglePlus
    rm -rf $S/app/GoogleTTS*
    rm -rf $S/app/GoogleVrCore*
    rm -rf $S/app/GoogleZhuyinIME*
    rm -rf $S/app/Hangouts
    rm -rf $S/app/KoreanIME*
    rm -rf $S/app/Maps
    rm -rf $S/app/Markup*
    rm -rf $S/app/Music2*
    rm -rf $S/app/Newsstand
    rm -rf $S/app/NexusWallpapers*
    rm -rf $S/app/Ornament
    rm -rf $S/app/Photos*
    rm -rf $S/app/PlayAutoInstallConfig*
    rm -rf $S/app/PlayGames*
    rm -rf $S/app/PrebuiltExchange3Google
    rm -rf $S/app/PrebuiltGmail
    rm -rf $S/app/PrebuiltKeep
    rm -rf $S/app/Street
    rm -rf $S/app/Stickers*
    rm -rf $S/app/TalkBack
    rm -rf $S/app/talkBack
    rm -rf $S/app/talkback
    rm -rf $S/app/TranslatePrebuilt
    rm -rf $S/app/Tycho
    rm -rf $S/app/Videos
    rm -rf $S/app/Wallet
    rm -rf $S/app/WallpapersBReel*
    rm -rf $S/app/YouTube
    rm -rf $S/etc/default-permissions/default-permissions.xml
    rm -rf $S/etc/default-permissions/opengapps-permissions.xml
    rm -rf $S/etc/permissions/default-permissions.xml
    rm -rf $S/etc/permissions/privapp-permissions-google.xml
    rm -rf $S/etc/permissions/privapp-permissions-google*
    rm -rf $S/etc/permissions/com.android.contacts.xml
    rm -rf $S/etc/permissions/com.android.dialer.xml
    rm -rf $S/etc/permissions/com.android.managedprovisioning.xml
    rm -rf $S/etc/permissions/com.android.provision.xml
    rm -rf $S/etc/permissions/com.google.android.camera*
    rm -rf $S/etc/permissions/com.google.android.dialer*
    rm -rf $S/etc/permissions/com.google.android.maps*
    rm -rf $S/etc/permissions/split-permissions-google.xml
    rm -rf $S/etc/preferred-apps/google.xml
    rm -rf $S/etc/preferred-apps/google_build.xml
    rm -rf $S/etc/sysconfig/pixel_2017_exclusive.xml
    rm -rf $S/etc/sysconfig/pixel_experience_2017.xml
    rm -rf $S/etc/sysconfig/gmsexpress.xml
    rm -rf $S/etc/sysconfig/googledialergo-sysconfig.xml
    rm -rf $S/etc/sysconfig/google-hiddenapi-package-whitelist.xml
    rm -rf $S/etc/sysconfig/google.xml
    rm -rf $S/etc/sysconfig/google_build.xml
    rm -rf $S/etc/sysconfig/google_experience.xml
    rm -rf $S/etc/sysconfig/google_exclusives_enable.xml
    rm -rf $S/etc/sysconfig/go_experience.xml
    rm -rf $S/etc/sysconfig/nga.xml
    rm -rf $S/etc/sysconfig/nexus.xml
    rm -rf $S/etc/sysconfig/pixel*
    rm -rf $S/etc/sysconfig/turbo.xml
    rm -rf $S/etc/sysconfig/wellbeing.xml
    rm -rf $S/framework/com.google.android.camera*
    rm -rf $S/framework/com.google.android.dialer*
    rm -rf $S/framework/com.google.android.maps*
    rm -rf $S/framework/oat/arm/com.google.android.camera*
    rm -rf $S/framework/oat/arm/com.google.android.dialer*
    rm -rf $S/framework/oat/arm/com.google.android.maps*
    rm -rf $S/framework/oat/arm64/com.google.android.camera*
    rm -rf $S/framework/oat/arm64/com.google.android.dialer*
    rm -rf $S/framework/oat/arm64/com.google.android.maps*
    rm -rf $S/lib/libaiai-annotators.so
    rm -rf $S/lib/libcronet.70.0.3522.0.so
    rm -rf $S/lib/libfilterpack_facedetect.so
    rm -rf $S/lib/libfrsdk.so
    rm -rf $S/lib/libgcam.so
    rm -rf $S/lib/libgcam_swig_jni.so
    rm -rf $S/lib/libocr.so
    rm -rf $S/lib/libparticle-extractor_jni.so
    rm -rf $S/lib64/libbarhopper.so
    rm -rf $S/lib64/libfacenet.so
    rm -rf $S/lib64/libfilterpack_facedetect.so
    rm -rf $S/lib64/libfrsdk.so
    rm -rf $S/lib64/libgcam.so
    rm -rf $S/lib64/libgcam_swig_jni.so
    rm -rf $S/lib64/libsketchology_native.so
    rm -rf $S/overlay/PixelConfigOverlay*
    rm -rf $S/priv-app/Aiai*
    rm -rf $S/priv-app/AmbientSense*
    rm -rf $S/priv-app/AndroidAuto*
    rm -rf $S/priv-app/AndroidMigrate*
    rm -rf $S/priv-app/AndroidPlatformServices
    rm -rf $S/priv-app/CalendarGoogle*
    rm -rf $S/priv-app/CalculatorGoogle*
    rm -rf $S/priv-app/Camera*
    rm -rf $S/priv-app/CarrierServices
    rm -rf $S/priv-app/CarrierSetup
    rm -rf $S/priv-app/ConfigUpdater
    rm -rf $S/priv-app/DataTransferTool
    rm -rf $S/priv-app/DeviceHealthServices
    rm -rf $S/priv-app/DevicePersonalizationServices
    rm -rf $S/priv-app/DigitalWellbeing*
    rm -rf $S/priv-app/FaceLock
    rm -rf $S/priv-app/Gcam*
    rm -rf $S/priv-app/GCam*
    rm -rf $S/priv-app/GCS
    rm -rf $S/priv-app/GmsCore*
    rm -rf $S/priv-app/GoogleCalculator*
    rm -rf $S/priv-app/GoogleCalendar*
    rm -rf $S/priv-app/GoogleCamera*
    rm -rf $S/priv-app/GoogleBackupTransport
    rm -rf $S/priv-app/GoogleExtservices
    rm -rf $S/priv-app/GoogleExtServicesPrebuilt
    rm -rf $S/priv-app/GoogleFeedback
    rm -rf $S/priv-app/GoogleOneTimeInitializer
    rm -rf $S/priv-app/GooglePartnerSetup
    rm -rf $S/priv-app/GoogleRestore
    rm -rf $S/priv-app/GoogleServicesFramework
    rm -rf $S/priv-app/HotwordEnrollment*
    rm -rf $S/priv-app/HotWordEnrollment*
    rm -rf $S/priv-app/matchmaker*
    rm -rf $S/priv-app/Matchmaker*
    rm -rf $S/priv-app/Phonesky
    rm -rf $S/priv-app/PixelLive*
    rm -rf $S/priv-app/PrebuiltGmsCore*
    rm -rf $S/priv-app/PixelSetupWizard*
    rm -rf $S/priv-app/SetupWizard*
    rm -rf $S/priv-app/Tag*
    rm -rf $S/priv-app/Tips*
    rm -rf $S/priv-app/Turbo*
    rm -rf $S/priv-app/Velvet
    rm -rf $S/priv-app/Wellbeing*
    rm -rf $S/usr/srec/en-US
    rm -rf $S/system_ext/addon.d/30*
    rm -rf $S/system_ext/addon.d/69*
    rm -rf $S/system_ext/addon.d/70*
    rm -rf $S/system_ext/addon.d/71*
    rm -rf $S/system_ext/addon.d/74*
    rm -rf $S/system_ext/addon.d/75*
    rm -rf $S/system_ext/addon.d/78*
    rm -rf $S/system_ext/addon.d/90*
    rm -rf $S/system_ext/app/AndroidAuto*
    rm -rf $S/system_ext/app/arcore
    rm -rf $S/system_ext/app/Books*
    rm -rf $S/system_ext/app/CarHomeGoogle
    rm -rf $S/system_ext/app/CalculatorGoogle*
    rm -rf $S/system_ext/app/CalendarGoogle*
    rm -rf $S/system_ext/app/CarHomeGoogle
    rm -rf $S/system_ext/app/Chrome*
    rm -rf $S/system_ext/app/CloudPrint*
    rm -rf $S/system_ext/app/DevicePersonalizationServices
    rm -rf $S/system_ext/app/DMAgent
    rm -rf $S/system_ext/app/Drive
    rm -rf $S/system_ext/app/Duo
    rm -rf $S/system_ext/app/EditorsDocs
    rm -rf $S/system_ext/app/Editorssheets
    rm -rf $S/system_ext/app/EditorsSlides
    rm -rf $S/system_ext/app/ExchangeServices
    rm -rf $S/system_ext/app/FaceLock
    rm -rf $S/system_ext/app/Fitness*
    rm -rf $S/system_ext/app/GalleryGo*
    rm -rf $S/system_ext/app/Gcam*
    rm -rf $S/system_ext/app/GCam*
    rm -rf $S/system_ext/app/Gmail*
    rm -rf $S/system_ext/app/GoogleCamera*
    rm -rf $S/system_ext/app/GoogleCalendar*
    rm -rf $S/system_ext/app/GoogleCalendarSyncAdapter
    rm -rf $S/system_ext/app/GoogleContactsSyncAdapter
    rm -rf $S/system_ext/app/GoogleCloudPrint
    rm -rf $S/system_ext/app/GoogleEarth
    rm -rf $S/system_ext/app/GoogleExtshared
    rm -rf $S/system_ext/app/GooglePrintRecommendationService
    rm -rf $S/system_ext/app/GoogleGo*
    rm -rf $S/system_ext/app/GoogleHome*
    rm -rf $S/system_ext/app/GoogleHindiIME*
    rm -rf $S/system_ext/app/GoogleKeep*
    rm -rf $S/system_ext/app/GoogleJapaneseInput*
    rm -rf $S/system_ext/app/GoogleLoginService*
    rm -rf $S/system_ext/app/GoogleMusic*
    rm -rf $S/system_ext/app/GoogleNow*
    rm -rf $S/system_ext/app/GooglePhotos*
    rm -rf $S/system_ext/app/GooglePinyinIME*
    rm -rf $S/system_ext/app/GooglePlus
    rm -rf $S/system_ext/app/GoogleTTS*
    rm -rf $S/system_ext/app/GoogleVrCore*
    rm -rf $S/system_ext/app/GoogleZhuyinIME*
    rm -rf $S/system_ext/app/Hangouts
    rm -rf $S/system_ext/app/KoreanIME*
    rm -rf $S/system_ext/app/Maps
    rm -rf $S/system_ext/app/Markup*
    rm -rf $S/system_ext/app/Music2*
    rm -rf $S/system_ext/app/Newsstand
    rm -rf $S/system_ext/app/NexusWallpapers*
    rm -rf $S/system_ext/app/Ornament
    rm -rf $S/system_ext/app/Photos*
    rm -rf $S/system_ext/app/PlayAutoInstallConfig*
    rm -rf $S/system_ext/app/PlayGames*
    rm -rf $S/system_ext/app/PrebuiltExchange3Google
    rm -rf $S/system_ext/app/PrebuiltGmail
    rm -rf $S/system_ext/app/PrebuiltKeep
    rm -rf $S/system_ext/app/Street
    rm -rf $S/system_ext/app/Stickers*
    rm -rf $S/system_ext/app/TalkBack
    rm -rf $S/system_ext/app/talkBack
    rm -rf $S/system_ext/app/talkback
    rm -rf $S/system_ext/app/TranslatePrebuilt
    rm -rf $S/system_ext/app/Tycho
    rm -rf $S/system_ext/app/Videos
    rm -rf $S/system_ext/app/Wallet
    rm -rf $S/system_ext/app/WallpapersBReel*
    rm -rf $S/system_ext/app/YouTube
    rm -rf $S/system_ext/etc/default-permissions/default-permissions.xml
    rm -rf $S/system_ext/etc/default-permissions/opengapps-permissions.xml
    rm -rf $S/system_ext/etc/permissions/default-permissions.xml
    rm -rf $S/system_ext/etc/permissions/privapp-permissions-google.xml
    rm -rf $S/system_ext/etc/permissions/privapp-permissions-google*
    rm -rf $S/system_ext/etc/permissions/com.android.contacts.xml
    rm -rf $S/system_ext/etc/permissions/com.android.dialer.xml
    rm -rf $S/system_ext/etc/permissions/com.android.managedprovisioning.xml
    rm -rf $S/system_ext/etc/permissions/com.android.provision.xml
    rm -rf $S/system_ext/etc/permissions/com.google.android.camera*
    rm -rf $S/system_ext/etc/permissions/com.google.android.dialer*
    rm -rf $S/system_ext/etc/permissions/com.google.android.maps*
    rm -rf $S/system_ext/etc/permissions/split-permissions-google.xml
    rm -rf $S/system_ext/etc/preferred-apps/google.xml
    rm -rf $S/system_ext/etc/preferred-apps/google_build.xml
    rm -rf $S/system_ext/etc/sysconfig/pixel_2017_exclusive.xml
    rm -rf $S/system_ext/etc/sysconfig/pixel_experience_2017.xml
    rm -rf $S/system_ext/etc/sysconfig/gmsexpress.xml
    rm -rf $S/system_ext/etc/sysconfig/googledialergo-sysconfig.xml
    rm -rf $S/system_ext/etc/sysconfig/google-hiddenapi-package-whitelist.xml
    rm -rf $S/system_ext/etc/sysconfig/google.xml
    rm -rf $S/system_ext/etc/sysconfig/google_build.xml
    rm -rf $S/system_ext/etc/sysconfig/google_experience.xml
    rm -rf $S/system_ext/etc/sysconfig/google_exclusives_enable.xml
    rm -rf $S/system_ext/etc/sysconfig/go_experience.xml
    rm -rf $S/system_ext/etc/sysconfig/nga.xml
    rm -rf $S/system_ext/etc/sysconfig/nexus.xml
    rm -rf $S/system_ext/etc/sysconfig/pixel*
    rm -rf $S/system_ext/etc/sysconfig/turbo.xml
    rm -rf $S/system_ext/etc/sysconfig/wellbeing.xml
    rm -rf $S/system_ext/framework/com.google.android.camera*
    rm -rf $S/system_ext/framework/com.google.android.dialer*
    rm -rf $S/system_ext/framework/com.google.android.maps*
    rm -rf $S/system_ext/framework/oat/arm/com.google.android.camera*
    rm -rf $S/system_ext/framework/oat/arm/com.google.android.dialer*
    rm -rf $S/system_ext/framework/oat/arm/com.google.android.maps*
    rm -rf $S/system_ext/framework/oat/arm64/com.google.android.camera*
    rm -rf $S/system_ext/framework/oat/arm64/com.google.android.dialer*
    rm -rf $S/system_ext/framework/oat/arm64/com.google.android.maps*
    rm -rf $S/system_ext/lib/libaiai-annotators.so
    rm -rf $S/system_ext/lib/libcronet.70.0.3522.0.so
    rm -rf $S/system_ext/lib/libfilterpack_facedetect.so
    rm -rf $S/system_ext/lib/libfrsdk.so
    rm -rf $S/system_ext/lib/libgcam.so
    rm -rf $S/system_ext/lib/libgcam_swig_jni.so
    rm -rf $S/system_ext/lib/libocr.so
    rm -rf $S/system_ext/lib/libparticle-extractor_jni.so
    rm -rf $S/system_ext/lib64/libbarhopper.so
    rm -rf $S/system_ext/lib64/libfacenet.so
    rm -rf $S/system_ext/lib64/libfilterpack_facedetect.so
    rm -rf $S/system_ext/lib64/libfrsdk.so
    rm -rf $S/system_ext/lib64/libgcam.so
    rm -rf $S/system_ext/lib64/libgcam_swig_jni.so
    rm -rf $S/system_ext/lib64/libsketchology_native.so
    rm -rf $S/system_ext/overlay/PixelConfigOverlay*
    rm -rf $S/system_ext/priv-app/Aiai*
    rm -rf $S/system_ext/priv-app/AmbientSense*
    rm -rf $S/system_ext/priv-app/AndroidAuto*
    rm -rf $S/system_ext/priv-app/AndroidMigrate*
    rm -rf $S/system_ext/priv-app/AndroidPlatformServices
    rm -rf $S/system_ext/priv-app/CalendarGoogle*
    rm -rf $S/system_ext/priv-app/CalculatorGoogle*
    rm -rf $S/system_ext/priv-app/Camera*
    rm -rf $S/system_ext/priv-app/CarrierServices
    rm -rf $S/system_ext/priv-app/CarrierSetup
    rm -rf $S/system_ext/priv-app/ConfigUpdater
    rm -rf $S/system_ext/priv-app/DataTransferTool
    rm -rf $S/system_ext/priv-app/DeviceHealthServices
    rm -rf $S/system_ext/priv-app/DevicePersonalizationServices
    rm -rf $S/system_ext/priv-app/DigitalWellbeing*
    rm -rf $S/system_ext/priv-app/FaceLock
    rm -rf $S/system_ext/priv-app/Gcam*
    rm -rf $S/system_ext/priv-app/GCam*
    rm -rf $S/system_ext/priv-app/GCS
    rm -rf $S/system_ext/priv-app/GmsCore*
    rm -rf $S/system_ext/priv-app/GoogleCalculator*
    rm -rf $S/system_ext/priv-app/GoogleCalendar*
    rm -rf $S/system_ext/priv-app/GoogleCamera*
    rm -rf $S/system_ext/priv-app/GoogleBackupTransport
    rm -rf $S/system_ext/priv-app/GoogleExtservices
    rm -rf $S/system_ext/priv-app/GoogleExtServicesPrebuilt
    rm -rf $S/system_ext/priv-app/GoogleFeedback
    rm -rf $S/system_ext/priv-app/GoogleOneTimeInitializer
    rm -rf $S/system_ext/priv-app/GooglePartnerSetup
    rm -rf $S/system_ext/priv-app/GoogleRestore
    rm -rf $S/system_ext/priv-app/GoogleServicesFramework
    rm -rf $S/system_ext/priv-app/HotwordEnrollment*
    rm -rf $S/system_ext/priv-app/HotWordEnrollment*
    rm -rf $S/system_ext/priv-app/matchmaker*
    rm -rf $S/system_ext/priv-app/Matchmaker*
    rm -rf $S/system_ext/priv-app/Phonesky
    rm -rf $S/system_ext/priv-app/PixelLive*
    rm -rf $S/system_ext/priv-app/PrebuiltGmsCore*
    rm -rf $S/system_ext/priv-app/PixelSetupWizard*
    rm -rf $S/system_ext/priv-app/SetupWizard*
    rm -rf $S/system_ext/priv-app/Tag*
    rm -rf $S/system_ext/priv-app/Tips*
    rm -rf $S/system_ext/priv-app/Turbo*
    rm -rf $S/system_ext/priv-app/Velvet
    rm -rf $S/system_ext/priv-app/Wellbeing*
    rm -rf $S/system_ext/usr/srec/en-US
    rm -rf $S/product/app/AndroidAuto*
    rm -rf $S/product/app/arcore
    rm -rf $S/product/app/Books*
    rm -rf $S/product/app/CalculatorGoogle*
    rm -rf $S/product/app/CalendarGoogle*
    rm -rf $S/product/app/CarHomeGoogle
    rm -rf $S/product/app/Chrome*
    rm -rf $S/product/app/CloudPrint*
    rm -rf $S/product/app/DMAgent
    rm -rf $S/product/app/DevicePersonalizationServices
    rm -rf $S/product/app/Drive
    rm -rf $S/product/app/Duo
    rm -rf $S/product/app/EditorsDocs
    rm -rf $S/product/app/Editorssheets
    rm -rf $S/product/app/EditorsSlides
    rm -rf $S/product/app/ExchangeServices
    rm -rf $S/product/app/FaceLock
    rm -rf $S/product/app/Fitness*
    rm -rf $S/product/app/GalleryGo*
    rm -rf $S/product/app/Gcam*
    rm -rf $S/product/app/GCam*
    rm -rf $S/product/app/Gmail*
    rm -rf $S/product/app/GoogleCamera*
    rm -rf $S/product/app/GoogleCalendar*
    rm -rf $S/product/app/GoogleContacts*
    rm -rf $S/product/app/GoogleCloudPrint
    rm -rf $S/product/app/GoogleEarth
    rm -rf $S/product/app/GoogleExtshared
    rm -rf $S/product/app/GoogleExtShared
    rm -rf $S/product/app/GoogleGalleryGo
    rm -rf $S/product/app/GoogleGo*
    rm -rf $S/product/app/GoogleHome*
    rm -rf $S/product/app/GoogleHindiIME*
    rm -rf $S/product/app/GoogleKeep*
    rm -rf $S/product/app/GoogleJapaneseInput*
    rm -rf $S/product/app/GoogleLoginService*
    rm -rf $S/product/app/GoogleMusic*
    rm -rf $S/product/app/GoogleNow*
    rm -rf $S/product/app/GooglePhotos*
    rm -rf $S/product/app/GooglePinyinIME*
    rm -rf $S/product/app/GooglePlus
    rm -rf $S/product/app/GoogleTTS*
    rm -rf $S/product/app/GoogleVrCore*
    rm -rf $S/product/app/GoogleZhuyinIME*
    rm -rf $S/product/app/Hangouts
    rm -rf $S/product/app/KoreanIME*
    rm -rf $S/product/app/LocationHistory*
    rm -rf $S/product/app/Maps
    rm -rf $S/product/app/Markup*
    rm -rf $S/product/app/MicropaperPrebuilt
    rm -rf $S/product/app/Music2*
    rm -rf $S/product/app/Newsstand
    rm -rf $S/product/app/NexusWallpapers*
    rm -rf $S/product/app/Ornament
    rm -rf $S/product/app/Photos*
    rm -rf $S/product/app/PlayAutoInstallConfig*
    rm -rf $S/product/app/PlayGames*
    rm -rf $S/product/app/PrebuiltBugle
    rm -rf $S/product/app/PrebuiltClockGoogle
    rm -rf $S/product/app/PrebuiltDeskClockGoogle
    rm -rf $S/product/app/PrebuiltExchange3Google
    rm -rf $S/product/app/PrebuiltGmail
    rm -rf $S/product/app/PrebuiltKeep
    rm -rf $S/product/app/SoundAmplifierPrebuilt
    rm -rf $S/product/app/Street
    rm -rf $S/product/app/Stickers*
    rm -rf $S/product/app/TalkBack
    rm -rf $S/product/app/talkBack
    rm -rf $S/product/app/talkback
    rm -rf $S/product/app/TranslatePrebuilt
    rm -rf $S/product/app/Tycho
    rm -rf $S/product/app/Videos
    rm -rf $S/product/app/Wallet
    rm -rf $S/product/app/WallpapersBReel*
    rm -rf $S/product/app/YouTube*
    rm -rf $S/product/etc/default-permissions/default-permissions.xml
    rm -rf $S/product/etc/default-permissions/opengapps-permissions.xml
    rm -rf $S/product/etc/permissions/default-permissions.xml
    rm -rf $S/product/etc/permissions/privapp-permissions-google.xml
    rm -rf $S/product/etc/permissions/privapp-permissions-google*
    rm -rf $S/product/etc/permissions/com.android.contacts.xml
    rm -rf $S/product/etc/permissions/com.android.dialer.xml
    rm -rf $S/product/etc/permissions/com.android.managedprovisioning.xml
    rm -rf $S/product/etc/permissions/com.android.provision.xml
    rm -rf $S/product/etc/permissions/com.google.android.camera*
    rm -rf $S/product/etc/permissions/com.google.android.dialer*
    rm -rf $S/product/etc/permissions/com.google.android.maps*
    rm -rf $S/product/etc/permissions/split-permissions-google.xml
    rm -rf $S/product/etc/preferred-apps/google.xml
    rm -rf $S/product/etc/preferred-apps/google_build.xml
    rm -rf $S/product/etc/sysconfig/pixel_2017_exclusive.xml
    rm -rf $S/product/etc/sysconfig/pixel_experience_2017.xml
    rm -rf $S/product/etc/sysconfig/gmsexpress.xml
    rm -rf $S/product/etc/sysconfig/googledialergo-sysconfig.xml
    rm -rf $S/product/etc/sysconfig/google-hiddenapi-package-whitelist.xml
    rm -rf $S/product/etc/sysconfig/google.xml
    rm -rf $S/product/etc/sysconfig/google_build.xml
    rm -rf $S/product/etc/sysconfig/google_experience.xml
    rm -rf $S/product/etc/sysconfig/google_exclusives_enable.xml
    rm -rf $S/product/etc/sysconfig/go_experience.xml
    rm -rf $S/product/etc/sysconfig/nexus.xml
    rm -rf $S/product/etc/sysconfig/nga.xml
    rm -rf $S/product/etc/sysconfig/pixel*
    rm -rf $S/product/etc/sysconfig/turbo.xml
    rm -rf $S/product/etc/sysconfig/wellbeing.xml
    rm -rf $S/product/framework/com.google.android.camera*
    rm -rf $S/product/framework/com.google.android.dialer*
    rm -rf $S/product/framework/com.google.android.maps*
    rm -rf $S/product/framework/oat/arm/com.google.android.camera*
    rm -rf $S/product/framework/oat/arm/com.google.android.dialer*
    rm -rf $S/product/framework/oat/arm/com.google.android.maps*
    rm -rf $S/product/framework/oat/arm64/com.google.android.camera*
    rm -rf $S/product/framework/oat/arm64/com.google.android.dialer*
    rm -rf $S/product/framework/oat/arm64/com.google.android.maps*
    rm -rf $S/product/lib/libaiai-annotators.so
    rm -rf $S/product/lib/libcronet.70.0.3522.0.so
    rm -rf $S/product/lib/libfilterpack_facedetect.so
    rm -rf $S/product/lib/libfrsdk.so
    rm -rf $S/product/lib/libgcam.so
    rm -rf $S/product/lib/libgcam_swig_jni.so
    rm -rf $S/product/lib/libocr.so
    rm -rf $S/product/lib/libparticle-extractor_jni.so
    rm -rf $S/product/lib64/libbarhopper.so
    rm -rf $S/product/lib64/libfacenet.so
    rm -rf $S/product/lib64/libfilterpack_facedetect.so
    rm -rf $S/product/lib64/libfrsdk.so
    rm -rf $S/product/lib64/libgcam.so
    rm -rf $S/product/lib64/libgcam_swig_jni.so
    rm -rf $S/product/lib64/libsketchology_native.so
    rm -rf $S/product/overlay/GoogleConfigOverlay*
    rm -rf $S/product/overlay/PixelConfigOverlay*
    rm -rf $S/product/overlay/Gms*
    rm -rf $S/product/priv-app/Aiai*
    rm -rf $S/product/priv-app/AmbientSense*
    rm -rf $S/product/priv-app/AndroidAuto*
    rm -rf $S/product/priv-app/AndroidMigrate*
    rm -rf $S/product/priv-app/AndroidPlatformServices
    rm -rf $S/product/priv-app/CalendarGoogle*
    rm -rf $S/product/priv-app/CalculatorGoogle*
    rm -rf $S/product/priv-app/Camera*
    rm -rf $S/product/priv-app/CarrierServices
    rm -rf $S/product/priv-app/CarrierSetup
    rm -rf $S/product/priv-app/ConfigUpdater
    rm -rf $S/product/priv-app/ConnMetrics
    rm -rf $S/product/priv-app/DataTransferTool
    rm -rf $S/product/priv-app/DeviceHealthServices
    rm -rf $S/product/priv-app/DevicePersonalizationServices
    rm -rf $S/product/priv-app/DigitalWellbeing*
    rm -rf $S/product/priv-app/FaceLock
    rm -rf $S/product/priv-app/Gcam*
    rm -rf $S/product/priv-app/GCam*
    rm -rf $S/product/priv-app/GCS
    rm -rf $S/product/priv-app/GmsCore*
    rm -rf $S/product/priv-app/GoogleBackupTransport
    rm -rf $S/product/priv-app/GoogleCalculator*
    rm -rf $S/product/priv-app/GoogleCalendar*
    rm -rf $S/product/priv-app/GoogleCamera*
    rm -rf $S/product/priv-app/GoogleContacts*
    rm -rf $S/product/priv-app/GoogleDialer
    rm -rf $S/product/priv-app/GoogleExtservices
    rm -rf $S/product/priv-app/GoogleExtServices
    rm -rf $S/product/priv-app/GoogleFeedback
    rm -rf $S/product/priv-app/GoogleOneTimeInitializer
    rm -rf $S/product/priv-app/GooglePartnerSetup
    rm -rf $S/product/priv-app/GoogleRestore
    rm -rf $S/product/priv-app/GoogleServicesFramework
    rm -rf $S/product/priv-app/HotwordEnrollment*
    rm -rf $S/product/priv-app/HotWordEnrollment*
    rm -rf $S/product/priv-app/MaestroPrebuilt
    rm -rf $S/product/priv-app/matchmaker*
    rm -rf $S/product/priv-app/Matchmaker*
    rm -rf $S/product/priv-app/Phonesky
    rm -rf $S/product/priv-app/PixelLive*
    rm -rf $S/product/priv-app/PrebuiltGmsCore*
    rm -rf $S/product/priv-app/PixelSetupWizard*
    rm -rf $S/product/priv-app/RecorderPrebuilt
    rm -rf $S/product/priv-app/SCONE
    rm -rf $S/product/priv-app/Scribe*
    rm -rf $S/product/priv-app/SetupWizard*
    rm -rf $S/product/priv-app/Tag*
    rm -rf $S/product/priv-app/Tips*
    rm -rf $S/product/priv-app/Turbo*
    rm -rf $S/product/priv-app/Velvet
    rm -rf $S/product/priv-app/WallpaperPickerGoogleRelease
    rm -rf $S/product/priv-app/Wellbeing*
    rm -rf $S/product/usr/srec/en-US
    rm -rf $S/app/Abstruct
    rm -rf $S/app/BasicDreams
    rm -rf $S/app/BlissPapers
    rm -rf $S/app/BookmarkProvider
    rm -rf $S/app/Browser*
    rm -rf $S/app/Camera*
    rm -rf $S/app/Chromium
    rm -rf $S/app/ColtPapers
    rm -rf $S/app/EasterEgg*
    rm -rf $S/app/EggGame
    rm -rf $S/app/Email*
    rm -rf $S/app/ExactCalculator
    rm -rf $S/app/Exchange2
    rm -rf $S/app/Gallery*
    rm -rf $S/app/GugelClock
    rm -rf $S/app/HTMLViewer
    rm -rf $S/app/Jelly
    rm -rf $S/app/messaging
    rm -rf $S/app/MiXplorer*
    rm -rf $S/app/Music*
    rm -rf $S/app/Partnerbookmark*
    rm -rf $S/app/PartnerBookmark*
    rm -rf $S/app/Phonograph
    rm -rf $S/app/PhotoTable
    rm -rf $S/app/RetroMusic*
    rm -rf $S/app/VanillaMusic
    rm -rf $S/app/Via*
    rm -rf $S/app/QPGallery
    rm -rf $S/app/QuickSearchBox
    rm -rf $S/priv-app/AudioFX
    rm -rf $S/priv-app/Camera*
    rm -rf $S/priv-app/Eleven
    rm -rf $S/priv-app/MatLog
    rm -rf $S/priv-app/MusicFX
    rm -rf $S/priv-app/OmniSwitch
    rm -rf $S/priv-app/Snap*
    rm -rf $S/priv-app/Tag*
    rm -rf $S/priv-app/Via*
    rm -rf $S/priv-app/VinylMusicPlayer
    rm -rf $S/system_ext/app/Abstruct
    rm -rf $S/system_ext/app/BasicDreams
    rm -rf $S/system_ext/app/BlissPapers
    rm -rf $S/system_ext/app/BookmarkProvider
    rm -rf $S/system_ext/app/Browser*
    rm -rf $S/system_ext/app/Camera*
    rm -rf $S/system_ext/app/Chromium
    rm -rf $S/system_ext/app/ColtPapers
    rm -rf $S/system_ext/app/EasterEgg*
    rm -rf $S/system_ext/app/EggGame
    rm -rf $S/system_ext/app/Email*
    rm -rf $S/system_ext/app/ExactCalculator
    rm -rf $S/system_ext/app/Exchange2
    rm -rf $S/system_ext/app/Gallery*
    rm -rf $S/system_ext/app/GugelClock
    rm -rf $S/system_ext/app/HTMLViewer
    rm -rf $S/system_ext/app/Jelly
    rm -rf $S/system_ext/app/messaging
    rm -rf $S/system_ext/app/MiXplorer*
    rm -rf $S/system_ext/app/Music*
    rm -rf $S/system_ext/app/Partnerbookmark*
    rm -rf $S/system_ext/app/PartnerBookmark*
    rm -rf $S/system_ext/app/Phonograph
    rm -rf $S/system_ext/app/PhotoTable
    rm -rf $S/system_ext/app/RetroMusic*
    rm -rf $S/system_ext/app/VanillaMusic
    rm -rf $S/system_ext/app/Via*
    rm -rf $S/system_ext/app/QPGallery
    rm -rf $S/system_ext/app/QuickSearchBox
    rm -rf $S/system_ext/priv-app/AudioFX
    rm -rf $S/system_ext/priv-app/Camera*
    rm -rf $S/system_ext/priv-app/Eleven
    rm -rf $S/system_ext/priv-app/MatLog
    rm -rf $S/system_ext/priv-app/MusicFX
    rm -rf $S/system_ext/priv-app/OmniSwitch
    rm -rf $S/system_ext/priv-app/Snap*
    rm -rf $S/system_ext/priv-app/Tag*
    rm -rf $S/system_ext/priv-app/Via*
    rm -rf $S/system_ext/priv-app/VinylMusicPlayer
    rm -rf $S/product/app/AboutBliss
    rm -rf $S/product/app/BasicDreams
    rm -rf $S/product/app/BlissStatistics
    rm -rf $S/product/app/BookmarkProvider
    rm -rf $S/product/app/Browser*
    rm -rf $S/product/app/Calendar*
    rm -rf $S/product/app/Camera*
    rm -rf $S/product/app/Dashboard
    rm -rf $S/product/app/DeskClock
    rm -rf $S/product/app/EasterEgg*
    rm -rf $S/product/app/Email*
    rm -rf $S/product/app/EmergencyInfo
    rm -rf $S/product/app/Etar
    rm -rf $S/product/app/Gallery*
    rm -rf $S/product/app/HTMLViewer
    rm -rf $S/product/app/Jelly
    rm -rf $S/product/app/Messaging
    rm -rf $S/product/app/messaging
    rm -rf $S/product/app/Music*
    rm -rf $S/product/app/Partnerbookmark*
    rm -rf $S/product/app/PartnerBookmark*
    rm -rf $S/product/app/PhotoTable*
    rm -rf $S/product/app/Recorder*
    rm -rf $S/product/app/RetroMusic*
    rm -rf $S/product/app/SimpleGallery
    rm -rf $S/product/app/Via*
    rm -rf $S/product/app/WallpaperZone
    rm -rf $S/product/app/QPGallery
    rm -rf $S/product/app/QuickSearchBox
    rm -rf $S/product/overlay/ChromeOverlay
    rm -rf $S/product/overlay/TelegramOverlay
    rm -rf $S/product/overlay/WhatsAppOverlay
    rm -rf $S/product/priv-app/AncientWallpaperZone
    rm -rf $S/product/priv-app/Camera*
    rm -rf $S/product/priv-app/Contacts
    rm -rf $S/product/priv-app/crDroidMusic
    rm -rf $S/product/priv-app/Dialer
    rm -rf $S/product/priv-app/Eleven
    rm -rf $S/product/priv-app/EmergencyInfo
    rm -rf $S/product/priv-app/Gallery2
    rm -rf $S/product/priv-app/MatLog
    rm -rf $S/product/priv-app/MusicFX
    rm -rf $S/product/priv-app/OmniSwitch
    rm -rf $S/product/priv-app/Recorder*
    rm -rf $S/product/priv-app/Snap*
    rm -rf $S/product/priv-app/Tag*
    rm -rf $S/product/priv-app/Via*
    rm -rf $S/product/priv-app/VinylMusicPlayer
    rm -rf $S/app/AppleNLP*
    rm -rf $S/app/AuroraDroid
    rm -rf $S/app/AuroraStore
    rm -rf $S/app/DejaVu*
    rm -rf $S/app/DroidGuard
    rm -rf $S/app/LocalGSM*
    rm -rf $S/app/LocalWiFi*
    rm -rf $S/app/MicroG*
    rm -rf $S/app/MozillaUnified*
    rm -rf $S/app/nlp*
    rm -rf $S/app/Nominatim*
    rm -rf $S/system_ext/app/AppleNLP*
    rm -rf $S/system_ext/app/AuroraDroid
    rm -rf $S/system_ext/app/AuroraStore
    rm -rf $S/system_ext/app/DejaVu*
    rm -rf $S/system_ext/app/DroidGuard
    rm -rf $S/system_ext/app/LocalGSM*
    rm -rf $S/system_ext/app/LocalWiFi*
    rm -rf $S/system_ext/app/MicroG*
    rm -rf $S/system_ext/app/MozillaUnified*
    rm -rf $S/system_ext/app/nlp*
    rm -rf $S/system_ext/app/Nominatim*
    rm -rf $S/product/app/AppleNLP*
    rm -rf $S/product/app/AuroraDroid
    rm -rf $S/product/app/AuroraStore
    rm -rf $S/product/app/DejaVu*
    rm -rf $S/product/app/DroidGuard
    rm -rf $S/product/app/LocalGSM*
    rm -rf $S/product/app/LocalWiFi*
    rm -rf $S/product/app/MicroG*
    rm -rf $S/product/app/MozillaUnified*
    rm -rf $S/product/app/nlp*
    rm -rf $S/product/app/Nominatim*
    rm -rf $S/priv-app/AuroraServices
    rm -rf $S/priv-app/FakeStore
    rm -rf $S/priv-app/GmsCore
    rm -rf $S/priv-app/GsfProxy
    rm -rf $S/priv-app/MicroG*
    rm -rf $S/priv-app/PatchPhonesky
    rm -rf $S/priv-app/Phonesky
    rm -rf $S/system_ext/priv-app/AuroraServices
    rm -rf $S/system_ext/priv-app/FakeStore
    rm -rf $S/system_ext/priv-app/GmsCore
    rm -rf $S/system_ext/priv-app/GsfProxy
    rm -rf $S/system_ext/priv-app/MicroG*
    rm -rf $S/system_ext/priv-app/PatchPhonesky
    rm -rf $S/system_ext/priv-app/Phonesky
    rm -rf $S/product/priv-app/AuroraServices
    rm -rf $S/product/priv-app/FakeStore
    rm -rf $S/product/priv-app/GmsCore
    rm -rf $S/product/priv-app/GsfProxy
    rm -rf $S/product/priv-app/MicroG*
    rm -rf $S/product/priv-app/PatchPhonesky
    rm -rf $S/product/priv-app/Phonesky
    rm -rf $S/etc/default-permissions/microg*
    rm -rf $S/etc/default-permissions/phonesky*
    rm -rf $S/etc/permissions/features.xml
    rm -rf $S/etc/permissions/com.android.vending*
    rm -rf $S/etc/permissions/com.aurora.services*
    rm -rf $S/etc/permissions/com.google.android.backup*
    rm -rf $S/etc/permissions/com.google.android.gms*
    rm -rf $S/etc/sysconfig/microg*
    rm -rf $S/etc/sysconfig/nogoolag*
    rm -rf $S/system_ext/etc/default-permissions/microg*
    rm -rf $S/system_ext/etc/default-permissions/phonesky*
    rm -rf $S/system_ext/etc/permissions/features.xml
    rm -rf $S/system_ext/etc/permissions/com.android.vending*
    rm -rf $S/system_ext/etc/permissions/com.aurora.services*
    rm -rf $S/system_ext/etc/permissions/com.google.android.backup*
    rm -rf $S/system_ext/etc/permissions/com.google.android.gms*
    rm -rf $S/system_ext/etc/sysconfig/microg*
    rm -rf $S/system_ext/etc/sysconfig/nogoolag*
    rm -rf $S/product/etc/default-permissions/microg*
    rm -rf $S/product/etc/default-permissions/phonesky*
    rm -rf $S/product/etc/permissions/features.xml
    rm -rf $S/product/etc/permissions/com.android.vending*
    rm -rf $S/product/etc/permissions/com.aurora.services*
    rm -rf $S/product/etc/permissions/com.google.android.backup*
    rm -rf $S/product/etc/permissions/com.google.android.gms*
    rm -rf $S/product/etc/sysconfig/microg*
    rm -rf $S/product/etc/sysconfig/nogoolag*
    rm -rf $S/bin/nanodroid*
    rm -rf $S/bin/novl
    rm -rf $S/bin/npem
    rm -rf $S/bin/nprp
    rm -rf $S/bin/nutl
    rm -rf $S/xbin/nanodroid*
    rm -rf $S/xbin/novl
    rm -rf $S/xbin/npem
    rm -rf $S/xbin/nprp
    rm -rf $S/xbin/nutl
  fi;
}

# Limit AOSP App installation from SDK30 to SDK27
lim_aosp_install() {
  if [ "$rwg_install_status" == "true" ]; then
    if [ -n "$(cat $S/build.prop | grep ro.pa.device)" ]; then
      if [ "$android_sdk" == "$supported_sdk_v30" ]; then
        pre_installed_ext;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v29" ]; then
        pre_installed;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v28" ]; then
        pre_installed;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v27" ]; then
        pre_installed;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v25" ]; then
        pre_installed;
      fi;
    fi;
    if [ -n "$(cat $S/build.prop | grep org.pixelexperience.version)" ]; then
      if [ "$android_sdk" == "$supported_sdk_v30" ]; then
        pre_installed_ext;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v29" ]; then
        pre_installed;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v28" ]; then
        pre_installed;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v27" ]; then
        pre_installed;
      fi;
    fi;
    if [ -n "$(cat $S/build.prop | grep org.evolution.device)" ]; then
      if [ "$android_sdk" == "$supported_sdk_v30" ]; then
        pre_installed_ext;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v29" ]; then
        pre_installed;
      fi;
      if [ "$android_sdk" == "$supported_sdk_v28" ]; then
        pre_installed;
      fi;
    fi;
  fi;
}

# Set backup function
backupdirSYS() {
  SYS_APP="
    $SYSTEM/app/FaceLock
    $SYSTEM/app/GoogleCalendarSyncAdapter
    $SYSTEM/app/GoogleContactsSyncAdapter"
    
  SYS_APP_JAR="
    $S/app/GoogleExtShared"

  SYS_BIN="
    $S/bin/pm.sh"

  SYS_PRIVAPP="
    $SYSTEM/priv-app/ConfigUpdater
    $SYSTEM/priv-app/GmsCoreSetupPrebuilt
    $SYSTEM/priv-app/GoogleLoginService
    $SYSTEM/priv-app/GoogleServicesFramework
    $SYSTEM/priv-app/Phonesky
    $SYSTEM/priv-app/PrebuiltGmsCore
    $SYSTEM/priv-app/PrebuiltGmsCorePix
    $SYSTEM/priv-app/PrebuiltGmsCorePi
    $SYSTEM/priv-app/PrebuiltGmsCoreQt
    $SYSTEM/priv-app/PrebuiltGmsCoreRvc"

  SYS_PRIVAPP_JAR="
    $S/priv-app/GoogleExtServices"

  SYS_FRAMEWORK="
    $SYSTEM/framework/com.google.android.dialer.support.jar
    $SYSTEM/framework/com.google.android.maps.jar
    $SYSTEM/framework/com.google.android.media.effects.jar"

  SYS_LIB="
    $SYSTEM/lib/libfilterpack_facedetect.so
    $SYSTEM/lib/libfrsdk.so"

  SYS_LIB64="
    $SYSTEM/lib64/libfacenet.so
    $SYSTEM/lib64/libfilterpack_facedetect.so
    $SYSTEM/lib64/libfrsdk.so"

  SYS_SYSCONFIG="
    $SYSTEM/etc/sysconfig/dialer_experience.xml
    $SYSTEM/etc/sysconfig/google.xml
    $SYSTEM/etc/sysconfig/google_build.xml
    $SYSTEM/etc/sysconfig/google_exclusives_enable.xml
    $SYSTEM/etc/sysconfig/google-hiddenapi-package-whitelist.xml
    $SYSTEM/etc/sysconfig/google-rollback-package-whitelist.xml
    $SYSTEM/etc/sysconfig/google-staged-installer-whitelist.xml
    $SYSTEM/etc/sysconfig/nexus.xml
    $SYSTEM/etc/sysconfig/nga.xml
    $SYSTEM/etc/sysconfig/pixel_2019_exclusive.xml
    $SYSTEM/etc/sysconfig/pixel_experience_2017.xml
    $SYSTEM/etc/sysconfig/pixel_experience_2018.xml
    $SYSTEM/etc/sysconfig/pixel_experience_2019_midyear.xml
    $SYSTEM/etc/sysconfig/pixel_experience_2019.xml
    $SYSTEM/etc/sysconfig/preinstalled-packages-product-pixel-2017-and-newer.xml"

  SYS_DEFAULTPERMISSIONS="
    $SYSTEM/etc/default-permissions/default-permissions.xml"

  SYS_PERMISSIONS="
    $SYSTEM/etc/permissions/com.google.android.dialer.support.xml
    $SYSTEM/etc/permissions/com.google.android.maps.xml
    $SYSTEM/etc/permissions/com.google.android.media.effects.xml
    $SYSTEM/etc/permissions/split-permissions-google.xml"

  SYS_PREFERREDAPPS="
    $SYSTEM/etc/preferred-apps/google.xml"

  SYS_PROPFILE="
    $S/etc/data.prop
    $S/etc/g.prop"

  SYS_BUILDFILE="
    $S/config.prop"

  SYS_XBIN="
    $S/xbin/sqlite3"
}

backupdirSYSFboot() {
  SYS_PRIVAPP_SETUP="
    $SYSTEM/priv-app/AndroidMigratePrebuilt
    $SYSTEM/priv-app/GoogleBackupTransport
    $SYSTEM/priv-app/GoogleRestore
    $SYSTEM/priv-app/SetupWizardPrebuilt"

  SYS_LIB64_SETUP="
    $SYSTEM/lib64/libbarhopper.so"
}

backupdirSYSRwg() {
  SYS_APP_RWG="
    $SYSTEM/app/Messaging"

  SYS_PRIVAPP_RWG="
    $SYSTEM/priv-app/Contacts
    $SYSTEM/priv-app/Dialer
    $SYSTEM/priv-app/ManagedProvisioning
    $SYSTEM/priv-app/Provision"

  SYS_PERMISSIONS_RWG="
    $SYSTEM/etc/permissions/com.android.contacts.xml
    $SYSTEM/etc/permissions/com.android.dialer.xml
    $SYSTEM/etc/permissions/com.android.managedprovisioning.xml
    $SYSTEM/etc/permissions/com.android.provision.xml"
}

backupdirSYSAddon() {
  SYS_APP_ADDON="
    $SYSTEM/app/CalculatorGooglePrebuilt
    $SYSTEM/app/CalendarGooglePrebuilt
    $SYSTEM/app/DeskClockGooglePrebuilt
    $SYSTEM/app/GboardGooglePrebuilt
    $SYSTEM/app/MarkupGooglePrebuilt
    $SYSTEM/app/MessagesGooglePrebuilt
    $SYSTEM/app/PhotosGooglePrebuilt
    $SYSTEM/app/SoundPickerPrebuilt
    $SYSTEM/app/YouTube
    $SYSTEM/app/MicroGGMSCore"

  SYS_PRIVAPP_ADDON="
    $SYSTEM/priv-app/CarrierServices
    $SYSTEM/priv-app/ContactsGooglePrebuilt
    $SYSTEM/priv-app/DialerGooglePrebuilt
    $SYSTEM/priv-app/Velvet
    $SYSTEM/priv-app/WellbeingPrebuilt"

  SYS_LIB_ADDON="
    $SYSTEM/lib/libsketchology_native.so"

  SYS_LIB64_ADDON="
    $SYSTEM/lib64/libsketchology_native.so"
}

# Set restore function
restoredirTMP() {
  TMP_APP="
    $TMP/app/FaceLock
    $TMP/app/GoogleCalendarSyncAdapter
    $TMP/app/GoogleContactsSyncAdapter"

  TMP_APP_JAR="
    $TMP/app/GoogleExtShared"

  TMP_BIN="
    $TMP/bin/pm.sh"

  TMP_PRIVAPP="
    $TMP/priv-app/ConfigUpdater
    $TMP/priv-app/GmsCoreSetupPrebuilt
    $TMP/priv-app/GoogleLoginService
    $TMP/priv-app/GoogleServicesFramework
    $TMP/priv-app/Phonesky
    $TMP/priv-app/PrebuiltGmsCore
    $TMP/priv-app/PrebuiltGmsCorePix
    $TMP/priv-app/PrebuiltGmsCorePi
    $TMP/priv-app/PrebuiltGmsCoreQt
    $TMP/priv-app/PrebuiltGmsCoreRvc"

  TMP_PRIVAPP_JAR="
    $TMP/priv-app/GoogleExtServices"

  TMP_FRAMEWORK="
    $TMP/framework/com.google.android.dialer.support.jar
    $TMP/framework/com.google.android.maps.jar
    $TMP/framework/com.google.android.media.effects.jar"

  TMP_LIB="
    $TMP/lib/libfilterpack_facedetect.so
    $TMP/lib/libfrsdk.so"

  TMP_LIB64="
    $TMP/lib64/libfacenet.so
    $TMP/lib64/libfilterpack_facedetect.so
    $TMP/lib64/libfrsdk.so"

  TMP_SYSCONFIG="
    $TMP/sysconfig/dialer_experience.xml
    $TMP/sysconfig/google.xml
    $TMP/sysconfig/google_build.xml
    $TMP/sysconfig/google_exclusives_enable.xml
    $TMP/sysconfig/google-hiddenapi-package-whitelist.xml
    $TMP/sysconfig/google-rollback-package-whitelist.xml
    $TMP/sysconfig/google-staged-installer-whitelist.xml
    $TMP/sysconfig/nexus.xml
    $TMP/sysconfig/nga.xml
    $TMP/sysconfig/pixel_2019_exclusive.xml
    $TMP/sysconfig/pixel_experience_2017.xml
    $TMP/sysconfig/pixel_experience_2018.xml
    $TMP/sysconfig/pixel_experience_2019_midyear.xml
    $TMP/sysconfig/pixel_experience_2019.xml
    $TMP/sysconfig/preinstalled-packages-product-pixel-2017-and-newer.xml"

  TMP_DEFAULTPERMISSIONS="
    $TMP/default-permissions/default-permissions.xml"

  TMP_PERMISSIONS="
    $TMP/permissions/com.google.android.dialer.support.xml
    $TMP/permissions/com.google.android.maps.xml
    $TMP/permissions/com.google.android.media.effects.xml
    $TMP/permissions/split-permissions-google.xml"

  TMP_PREFERREDAPPS="
    $TMP/preferred-apps/google.xml"

  TMP_PROPFILE="
    $TMP/etc/data.prop
    $TMP/etc/g.prop"

  TMP_BUILDFILE="
    $TMP/config.prop"

  TMP_XBIN="
    $TMP/xbin/sqlite3"
}

restoredirTMPFboot() {
  TMP_PRIVAPP_SETUP="
    $TMP/fboot/priv-app/AndroidMigratePrebuilt
    $TMP/fboot/priv-app/GoogleBackupTransport
    $TMP/fboot/priv-app/GoogleRestore
    $TMP/fboot/priv-app/SetupWizardPrebuilt"

  TMP_LIB64_SETUP="
    $TMP/fboot/lib64/libbarhopper.so"
}

restoredirTMPRwg() {
  TMP_APP_RWG="
    $TMP/rwg/app/Messaging"

  TMP_PRIVAPP_RWG="
    $TMP/rwg/priv-app/Contacts
    $TMP/rwg/priv-app/Dialer
    $TMP/rwg/priv-app/ManagedProvisioning
    $TMP/rwg/priv-app/Provision"

  TMP_PERMISSIONS_RWG="
    $TMP/rwg/permissions/com.android.contacts.xml
    $TMP/rwg/permissions/com.android.dialer.xml
    $TMP/rwg/permissions/com.android.managedprovisioning.xml
    $TMP/rwg/permissions/com.android.provision.xml"
}

restoredirTMPAddon() {
  TMP_APP_ADDON="
    $TMP/addon/app/CalculatorGooglePrebuilt
    $TMP/addon/app/CalendarGooglePrebuilt
    $TMP/addon/app/DeskClockGooglePrebuilt
    $TMP/addon/app/GboardGooglePrebuilt
    $TMP/addon/app/MarkupGooglePrebuilt
    $TMP/addon/app/MessagesGooglePrebuilt
    $TMP/addon/app/PhotosGooglePrebuilt
    $TMP/addon/app/SoundPickerPrebuilt
    $TMP/addon/app/YouTube
    $TMP/addon/app/MicroGGMSCore"

  TMP_PRIVAPP_ADDON="
    $TMP/addon/priv-app/CarrierServices
    $TMP/addon/priv-app/ContactsGooglePrebuilt
    $TMP/addon/priv-app/DialerGooglePrebuilt
    $TMP/addon/priv-app/Velvet
    $TMP/addon/priv-app/WellbeingPrebuilt"

  TMP_LIB_ADDON="
    $TMP/addon/lib/libsketchology_native.so"

  TMP_LIB64_ADDON="
    $TMP/addon/lib64/libsketchology_native.so"
}

backup_conflicting_packages() {
  if [ "$addon_install_status" == "conf" ] || [ "$addon_install_status" == "sep" ]; then
    # Backup CalendarProvider
    test -d $S/app/CalendarProvider && SYS_APP_CP="true" || SYS_APP_CP="false";
    test -d $S/priv-app/CalendarProvider && SYS_PRIV_CP="true" || SYS_PRIV_CP="false";
    test -d $S/product/app/CalendarProvider && PRO_APP_CP="true" || PRO_APP_CP="false";
    test -d $S/product/priv-app/CalendarProvider && PRO_PRIV_CP="true" || PRO_PRIV_CP="false";
    test -d $S/system_ext/app/CalendarProvider && SYS_APP_EXT_CP="true" || SYS_APP_EXT_CP="false";
    test -d $S/system_ext/priv-app/CalendarProvider && SYS_PRIV_EXT_CP="true" || SYS_PRIV_EXT_CP="false";
    if [ "$SYS_APP_CP" == "true" ]; then
      mv $S/app/CalendarProvider $TMP/addon/core/CalendarProvider
      echo >> $TMP/SYS_APP_CP
    fi;
    if [ "$SYS_PRIV_CP" == "true" ]; then
      mv $S/priv-app/CalendarProvider $TMP/addon/core/CalendarProvider
      echo >> $TMP/SYS_PRIV_CP
    fi;
    if [ "$PRO_APP_CP" == "true" ]; then
      mv $S/product/app/CalendarProvider $TMP/addon/core/CalendarProvider
      echo >> $TMP/PRO_APP_CP
    fi;
    if [ "$PRO_PRIV_CP" == "true" ]; then
      mv $S/product/priv-app/CalendarProvider $TMP/addon/core/CalendarProvider
      echo >> $TMP/PRO_PRIV_CP
    fi;
    if [ "$SYS_APP_EXT_CP" == "true" ]; then
      mv $S/system_ext/app/CalendarProvider $TMP/addon/core/CalendarProvider
      echo >> $TMP/SYS_APP_EXT_CP
    fi;
    if [ "$SYS_PRIV_EXT_CP" == "true" ]; then
      mv $S/system_ext/priv-app/CalendarProvider $TMP/addon/core/CalendarProvider
      echo >> $TMP/SYS_PRIV_EXT_CP
    fi;
    # Backup ContactsProvider
    test -d $S/app/ContactsProvider && SYS_APP_CTT="true" || SYS_APP_CTT="false";
    test -d $S/priv-app/ContactsProvider && SYS_PRIV_CTT="true" || SYS_PRIV_CTT="false";
    test -d $S/product/app/ContactsProvider && PRO_APP_CTT="true" || PRO_APP_CTT="false";
    test -d $S/product/priv-app/ContactsProvider && PRO_PRIV_CTT="true" || PRO_PRIV_CTT="false";
    test -d $S/system_ext/app/ContactsProvider && SYS_APP_EXT_CTT="true" || SYS_APP_EXT_CTT="false";
    test -d $S/system_ext/priv-app/ContactsProvider && SYS_PRIV_EXT_CTT="true" || SYS_PRIV_EXT_CTT="false";
    if [ "$SYS_APP_CTT" == "true" ]; then
      mv $S/app/ContactsProvider $TMP/addon/core/ContactsProvider
      echo >> $TMP/SYS_APP_CTT
    fi;
    if [ "$SYS_PRIV_CTT" == "true" ]; then
      mv $S/priv-app/ContactsProvider $TMP/addon/core/ContactsProvider
      echo >> $TMP/SYS_PRIV_CTT
    fi;
    if [ "$PRO_APP_CTT" == "true" ]; then
      mv $S/product/app/ContactsProvider $TMP/addon/core/ContactsProvider
      echo >> $TMP/PRO_APP_CTT
    fi;
    if [ "$PRO_PRIV_CTT" == "true" ]; then
      mv $S/product/priv-app/ContactsProvider $TMP/addon/core/ContactsProvider
      echo >> $TMP/PRO_PRIV_CTT
    fi;
    if [ "$SYS_APP_EXT_CTT" == "true" ]; then
      mv $S/system_ext/app/ContactsProvider $TMP/addon/core/ContactsProvider
      echo >> $TMP/SYS_APP_EXT_CTT
    fi;
    if [ "$SYS_PRIV_EXT_CTT" == "true" ]; then
      mv $S/system_ext/priv-app/ContactsProvider $TMP/addon/core/ContactsProvider
      echo >> $TMP/SYS_PRIV_EXT_CTT
    fi;
  fi;
}

trigger_fboot_backup() {
  if [ "$setup_install_status" == "conf" ]; then
    mv $SYS_PRIVAPP_SETUP $TMP/fboot/priv-app 2>/dev/null;
    mv $SYS_LIB64_SETUP $TMP/fboot/lib64 2>/dev/null;
  fi;
}

trigger_fboot_restore() {
  if [ "$setup_install_status" == "conf" ]; then
    mv $TMP_PRIVAPP_SETUP $SYSTEM/priv-app 2>/dev/null;
    mv $TMP_LIB64_SETUP $SYSTEM/lib64 2>/dev/null;
  fi;
}

trigger_rwg_backup() {
  if [ "$rwg_install_status" == "true" ]; then
    mv $SYS_APP_RWG $TMP/rwg/app 2>/dev/null;
    mv $SYS_PRIVAPP_RWG $TMP/rwg/priv-app 2>/dev/null;
    mv $SYS_PERMISSIONS_RWG $TMP/rwg/permissions 2>/dev/null;
  fi;
}

trigger_rwg_restore() {
  if [ "$rwg_install_status" == "true" ]; then
    mv $TMP_APP_RWG $SYSTEM/app 2>/dev/null;
    mv $TMP_PRIVAPP_RWG $SYSTEM/priv-app 2>/dev/null;
    mv $TMP_PERMISSIONS_RWG $SYSTEM/etc/permissions 2>/dev/null;
  fi;
}

trigger_addon_backup() {
  if [ "$addon_install_status" == "conf" ] || [ "$addon_install_status" == "sep" ]; then
    mv $SYS_APP_ADDON $TMP/addon/app 2>/dev/null;
    mv $SYS_PRIVAPP_ADDON $TMP/addon/priv-app 2>/dev/null;
    mv $SYS_LIB_ADDON $TMP/addon/lib 2>/dev/null;
    mv $SYS_LIB64_ADDON $TMP/addon/lib64 2>/dev/null;
  fi;
}

trigger_addon_restore() {
  if [ "$addon_install_status" == "conf" ] || [ "$addon_install_status" == "sep" ]; then
    mv $TMP_APP_ADDON $SYSTEM/app 2>/dev/null;
    mv $TMP_PRIVAPP_ADDON $SYSTEM/priv-app 2>/dev/null;
    mv $TMP_LIB_ADDON $SYSTEM/lib 2>/dev/null;
    mv $TMP_LIB64_ADDON $SYSTEM/lib64 2>/dev/null;
  fi;
}

# Create FaceLock lib symlink
bind_facelock_lib() {
  if [ "$android_sdk" == "$supported_sdk_v28" ] || [ "$android_sdk" == "$supported_sdk_v27" ] || [ "$android_sdk" == "$supported_sdk_v25" ]; then
    ln -sfnv $SYSTEM/lib64/libfacenet.so $SYSTEM/app/FaceLock/lib/arm64/libfacenet.so
  fi;
}

# Create SetupWizard lib symlink
bind_setupwizard_lib() {
  if [ "$android_sdk" == "$supported_sdk_v28" ]; then
    ln -sfnv $SYSTEM/lib64/libbarhopper.so $SYSTEM/app/SetupWizardPrebuilt/lib/arm64/libbarhopper.so
  fi;
}

# Wipe conflicting packages
fix_setup_conflict() {
  if [ "$setup_install_status" == "conf" ]; then
    rm -rf $S/app/ManagedProvisioning
    rm -rf $S/app/Provision
    rm -rf $S/app/LineageSetupWizard
    rm -rf $S/priv-app/ManagedProvisioning
    rm -rf $S/priv-app/Provision
    rm -rf $S/priv-app/LineageSetupWizard
    rm -rf $S/product/app/ManagedProvisioning
    rm -rf $S/product/app/Provision
    rm -rf $S/product/app/LineageSetupWizard
    rm -rf $S/product/priv-app/ManagedProvisioning
    rm -rf $S/product/priv-app/Provision
    rm -rf $S/product/priv-app/LineageSetupWizard
    rm -rf $S/system_ext/app/ManagedProvisioning
    rm -rf $S/system_ext/app/Provision
    rm -rf $S/system_ext/app/LineageSetupWizard
    rm -rf $S/system_ext/priv-app/ManagedProvisioning
    rm -rf $S/system_ext/priv-app/Provision
    rm -rf $S/system_ext/priv-app/LineageSetupWizard
    rm -rf $S/etc/permissions/com.android.managedprovisioning.xml
    rm -rf $S/etc/permissions/com.android.provision.xml
    rm -rf $S/product/etc/permissions/com.android.managedprovisioning.xml
    rm -rf $S/product/etc/permissions/com.android.provision.xml
    rm -rf $S/system_ext/etc/permissions/com.android.managedprovisioning.xml
    rm -rf $S/system_ext/etc/permissions/com.android.provision.xml
  fi;
}

# Wipe conflicting packages
fix_addon_conflict() {
  if [ "$addon_install_status" == "conf" ] || [ "$addon_install_status" == "sep" ]; then
    if [ -n "$(cat $S/config.prop | grep ro.config.calculator)" ]; then
      rm -rf $S/app/Calculator*
      rm -rf $S/app/calculator*
      rm -rf $S/app/ExactCalculator
      rm -rf $S/app/Exactcalculator
      rm -rf $S/priv-app/Calculator*
      rm -rf $S/priv-app/calculator*
      rm -rf $S/priv-app/ExactCalculator
      rm -rf $S/priv-app/Exactcalculator
      rm -rf $S/product/app/Calculator*
      rm -rf $S/product/app/calculator*
      rm -rf $S/product/priv-app/Calculator*
      rm -rf $S/product/priv-app/calculator*
      rm -rf $S/product/priv-app/ExactCalculator
      rm -rf $S/product/priv-app/Exactcalculator
      rm -rf $S/system_ext/app/Calculator*
      rm -rf $S/system_ext/app/calculator*
      rm -rf $S/system_ext/app/ExactCalculator
      rm -rf $S/system_ext/app/Exactcalculator
      rm -rf $S/system_ext/priv-app/Calculator*
      rm -rf $S/system_ext/priv-app/calculator*
      rm -rf $S/system_ext/priv-app/ExactCalculator
      rm -rf $S/system_ext/priv-app/Exactcalculator
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.calendar)" ]; then
      rm -rf $S/app/Calendar*
      rm -rf $S/app/calendar*
      rm -rf $S/app/Etar
      rm -rf $S/priv-app/Calendar*
      rm -rf $S/priv-app/calendar*
      rm -rf $S/priv-app/Etar
      rm -rf $S/product/app/Calendar*
      rm -rf $S/product/app/calendar*
      rm -rf $S/product/app/Etar
      rm -rf $S/product/priv-app/Calendar*
      rm -rf $S/product/priv-app/calendar*
      rm -rf $S/product/priv-app/Etar
      rm -rf $S/system_ext/app/Calendar*
      rm -rf $S/system_ext/app/calendar*
      rm -rf $S/system_ext/app/Etar
      rm -rf $S/system_ext/priv-app/Calendar*
      rm -rf $S/system_ext/priv-app/calendar*
      rm -rf $S/system_ext/priv-app/Etar
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.contacts)" ]; then
      rm -rf $S/app/Contacts*
      rm -rf $S/app/contacts*
      rm -rf $S/priv-app/Contacts*
      rm -rf $S/priv-app/contacts*
      rm -rf $S/product/app/Contacts*
      rm -rf $S/product/app/contacts*
      rm -rf $S/product/priv-app/Contacts*
      rm -rf $S/product/priv-app/contacts*
      rm -rf $S/system_ext/app/Contacts*
      rm -rf $S/system_ext/app/contacts*
      rm -rf $S/system_ext/priv-app/Contacts*
      rm -rf $S/system_ext/priv-app/contacts*
      rm -rf $S/etc/permissions/com.android.contacts.xml
      rm -rf $S/product/etc/permissions/com.android.contacts.xml
      rm -rf $S/system_ext/etc/permissions/com.android.contacts.xml
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.deskclock)" ]; then
      rm -rf $S/app/DeskClock*
      rm -rf $S/app/Clock*
      rm -rf $S/priv-app/DeskClock*
      rm -rf $S/priv-app/Clock*
      rm -rf $S/product/app/DeskClock*
      rm -rf $S/product/app/Clock*
      rm -rf $S/product/priv-app/DeskClock*
      rm -rf $S/product/priv-app/Clock*
      rm -rf $S/system_ext/app/DeskClock*
      rm -rf $S/system_ext/app/Clock*
      rm -rf $S/system_ext/priv-app/DeskClock*
      rm -rf $S/system_ext/priv-app/Clock*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.dialer)" ]; then
      rm -rf $S/app/Dialer*
      rm -rf $S/app/dialer*
      rm -rf $S/priv-app/Dialer*
      rm -rf $S/priv-app/dialer*
      rm -rf $S/product/app/Dialer*
      rm -rf $S/product/app/dialer*
      rm -rf $S/product/priv-app/Dialer*
      rm -rf $S/product/priv-app/dialer*
      rm -rf $S/system_ext/app/Dialer*
      rm -rf $S/system_ext/app/dialer*
      rm -rf $S/system_ext/priv-app/Dialer*
      rm -rf $S/system_ext/priv-app/dialer*
      rm -rf $S/etc/permissions/com.android.dialer.xml
      rm -rf $S/product/etc/permissions/com.android.dialer.xml
      rm -rf $S/system_ext/etc/permissions/com.android.dialer.xml
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.gboard)" ]; then
      rm -rf $S/app/Gboard*
      rm -rf $S/app/gboard*
      rm -rf $S/priv-app/Gboard*
      rm -rf $S/priv-app/gboard*
      rm -rf $S/product/app/Gboard*
      rm -rf $S/product/app/gboard*
      rm -rf $S/product/priv-app/Gboard*
      rm -rf $S/product/priv-app/gboard*
      rm -rf $S/system_ext/app/Gboard*
      rm -rf $S/system_ext/app/gboard*
      rm -rf $S/system_ext/priv-app/Gboard*
      rm -rf $S/system_ext/priv-app/gboard*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.markup)" ]; then
      rm -rf $S/app/MarkupGoogle*
      rm -rf $S/priv-app/MarkupGoogle*
      rm -rf $S/product/app/MarkupGoogle*
      rm -rf $S/product/priv-app/MarkupGoogle*
      rm -rf $S/system_ext/app/MarkupGoogle*
      rm -rf $S/system_ext/priv-app/MarkupGoogle*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.messages)" ]; then
      rm -rf $S/app/Messages*
      rm -rf $S/app/messages*
      rm -rf $S/app/Messaging*
      rm -rf $S/app/messaging*
      rm -rf $S/priv-app/Messages*
      rm -rf $S/priv-app/messages*
      rm -rf $S/priv-app/Messaging*
      rm -rf $S/priv-app/messaging*
      rm -rf $S/product/app/Messages*
      rm -rf $S/product/app/messages*
      rm -rf $S/product/app/Messaging*
      rm -rf $S/product/app/messaging*
      rm -rf $S/product/priv-app/Messages*
      rm -rf $S/product/priv-app/messages*
      rm -rf $S/product/priv-app/Messaging*
      rm -rf $S/product/priv-app/messaging*
      rm -rf $S/system_ext/app/Messages*
      rm -rf $S/system_ext/app/messages*
      rm -rf $S/system_ext/app/Messaging*
      rm -rf $S/system_ext/app/messaging*
      rm -rf $S/system_ext/priv-app/Messages*
      rm -rf $S/system_ext/priv-app/messages*
      rm -rf $S/system_ext/priv-app/Messaging*
      rm -rf $S/system_ext/priv-app/messaging*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.photos)" ]; then
      rm -rf $S/app/Photos*
      rm -rf $S/app/photos*
      rm -rf $S/priv-app/Photos*
      rm -rf $S/priv-app/photos*
      rm -rf $S/product/app/Photos*
      rm -rf $S/product/app/photos*
      rm -rf $S/product/priv-app/Photos*
      rm -rf $S/product/priv-app/photos*
      rm -rf $S/system_ext/app/Photos*
      rm -rf $S/system_ext/app/photos*
      rm -rf $S/system_ext/priv-app/Photos*
      rm -rf $S/system_ext/priv-app/photos*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.soundpicker)" ]; then
      rm -rf $S/app/SoundPicker*
      rm -rf $S/priv-app/SoundPicker*
      rm -rf $S/product/app/SoundPicker*
      rm -rf $S/product/priv-app/SoundPicker*
      rm -rf $S/system_ext/app/SoundPicker*
      rm -rf $S/system_ext/priv-app/SoundPicker*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.assistant)" ]; then
      rm -rf $S/app/Velvet*
      rm -rf $S/app/velvet*
      rm -rf $S/priv-app/Velvet*
      rm -rf $S/priv-app/velvet*
      rm -rf $S/product/app/Velvet*
      rm -rf $S/product/app/velvet*
      rm -rf $S/product/priv-app/Velvet*
      rm -rf $S/product/priv-app/velvet*
      rm -rf $S/system_ext/app/Velvet*
      rm -rf $S/system_ext/app/velvet*
      rm -rf $S/system_ext/priv-app/Velvet*
      rm -rf $S/system_ext/priv-app/velvet*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.wellbeing)" ]; then
      rm -rf $S/app/Wellbeing*
      rm -rf $S/app/wellbeing*
      rm -rf $S/priv-app/Wellbeing*
      rm -rf $S/priv-app/wellbeing*
      rm -rf $S/product/app/Wellbeing*
      rm -rf $S/product/app/wellbeing*
      rm -rf $S/product/priv-app/Wellbeing*
      rm -rf $S/product/priv-app/wellbeing*
      rm -rf $S/system_ext/app/Wellbeing*
      rm -rf $S/system_ext/app/wellbeing*
      rm -rf $S/system_ext/priv-app/Wellbeing*
      rm -rf $S/system_ext/priv-app/wellbeing*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.vanced)" ]; then
      rm -rf $S/app/YouTube*
      rm -rf $S/app/Youtube*
      rm -rf $S/priv-app/YouTube*
      rm -rf $S/priv-app/Youtube*
      rm -rf $S/product/app/YouTube*
      rm -rf $S/product/app/Youtube*
      rm -rf $S/product/priv-app/YouTube*
      rm -rf $S/product/priv-app/Youtube*
      rm -rf $S/system_ext/app/YouTube*
      rm -rf $S/system_ext/app/Youtube*
      rm -rf $S/system_ext/priv-app/YouTube*
      rm -rf $S/system_ext/priv-app/Youtube*
    fi;
    if [ -n "$(cat $S/config.prop | grep ro.config.vancedmicrog)" ]; then
      rm -rf $S/app/MicroG*
      rm -rf $S/app/microg*
      rm -rf $S/priv-app/MicroG*
      rm -rf $S/priv-app/microg*
      rm -rf $S/product/app/MicroG*
      rm -rf $S/product/app/microg*
      rm -rf $S/product/priv-app/MicroG*
      rm -rf $S/product/priv-app/microg*
      rm -rf $S/system_ext/app/MicroG*
      rm -rf $S/system_ext/app/microg*
      rm -rf $S/system_ext/priv-app/MicroG*
      rm -rf $S/system_ext/priv-app/microg*
    fi;
  fi;
}

restore_conflicting_packages() {
  if [ "$addon_install_status" == "conf" ] || [ "$addon_install_status" == "sep" ]; then
    # Restore CalendarProvider
    if [ -f "$TMP/SYS_APP_CP" ]; then
      mv $TMP/addon/core/CalendarProvider $S/app/CalendarProvider
    fi;
    if [ -f "$TMP/SYS_PRIV_CP" ]; then
      mv $TMP/addon/core/CalendarProvider $S/priv-app/CalendarProvider
    fi;
    if [ -f "$TMP/PRO_APP_CP" ]; then
      mv $TMP/addon/core/CalendarProvider $S/product/app/CalendarProvider
    fi;
    if [ -f "$TMP/PRO_PRIV_CP" ]; then
      mv $TMP/addon/core/CalendarProvider $S/product/priv-app/CalendarProvider
    fi;
    if [ -f "$TMP/SYS_APP_EXT_CP" ]; then
      mv $TMP/addon/core/CalendarProvider $S/system_ext/app/CalendarProvider
    fi;
    if [ -f "$TMP/SYS_PRIV_EXT_CP" ]; then
      mv $TMP/addon/core/CalendarProvider $S/system_ext/priv-app/CalendarProvider
    fi;
    # Restore ContactsProvider
    if [ -f "$TMP/SYS_APP_CTT" ]; then
      mv $TMP/addon/core/ContactsProvider $S/app/ContactsProvider
    fi;
    if [ -f "$TMP/SYS_PRIV_CTT" ]; then
      mv $TMP/addon/core/ContactsProvider $S/priv-app/ContactsProvider
    fi;
    if [ -f "$TMP/PRO_APP_CTT" ]; then
      mv $TMP/addon/core/ContactsProvider $S/product/app/ContactsProvider
    fi;
    if [ -f "$TMP/PRO_PRIV_CTT" ]; then
      mv $TMP/addon/core/ContactsProvider $S/product/priv-app/ContactsProvider
    fi;
    if [ -f "$TMP/SYS_APP_EXT_CTT" ]; then
      mv $TMP/addon/core/ContactsProvider $S/system_ext/app/ContactsProvider
    fi;
    if [ -f "$TMP/SYS_PRIV_EXT_CTT" ]; then
      mv $TMP/addon/core/ContactsProvider $S/system_ext/priv-app/ContactsProvider
    fi;
  fi;
}

# Call functions
trampoline;
tmp_dir;
on_sdk;
on_partition_check;
on_fstab;
ab_partition;
system_as_root;
super_partition;
mount_all;
system_layout;
on_version_check;
set_pathmap;

case "$1" in
  pre-backup)
    # Stub
  ;;
  backup)
    # Stub
    ui_print "BackupTools: Starting BiTGApps backup";
    backupdirSYS;
    mv $SYS_APP $TMP/app 2>/dev/null;
    mv $SYS_APP_JAR $TMP/app 2>/dev/null;
    mv $SYS_BIN $TMP/bin 2>/dev/null;
    mv $SYS_PRIVAPP $TMP/priv-app 2>/dev/null;
    mv $SYS_PRIVAPP_JAR $TMP/priv-app 2>/dev/null;
    mv $SYS_FRAMEWORK $TMP/framework 2>/dev/null;
    mv $SYS_LIB $TMP/lib 2>/dev/null;
    mv $SYS_LIB64 $TMP/lib64 2>/dev/null;
    mv $SYS_SYSCONFIG $TMP/sysconfig 2>/dev/null;
    mv $SYS_DEFAULTPERMISSIONS $TMP/default-permissions 2>/dev/null;
    mv $SYS_PERMISSIONS $TMP/permissions 2>/dev/null;
    mv $SYS_PREFERREDAPPS $TMP/preferred-apps 2>/dev/null;
    mv $SYS_PROPFILE $TMP/etc 2>/dev/null;
    mv $SYS_BUILDFILE $TMP 2>/dev/null;
    mv $SYS_XBIN $TMP/xbin 2>/dev/null;
    backupdirSYSAddon;
    on_addon_status_check;
    trigger_addon_backup;
    backup_conflicting_packages;
    backupdirSYSFboot;
    on_setup_status_check;
    trigger_fboot_backup;
    backupdirSYSRwg;
    on_rwg_status_check;
    trigger_rwg_backup;
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
    ui_print "BackupTools: Restoring BiTGApps backup";
    on_rwg_status_check;
    lim_aosp_install;
    restoredirTMP;
    mv $TMP_APP $SYSTEM/app 2>/dev/null;
    mv $TMP_APP_JAR $S/app 2>/dev/null;
    mv $TMP_BIN $S/bin 2>/dev/null;
    mv $TMP_PRIVAPP $SYSTEM/priv-app 2>/dev/null;
    mv $TMP_PRIVAPP_JAR $S/priv-app 2>/dev/null;
    mv $TMP_FRAMEWORK $SYSTEM/framework 2>/dev/null;
    mv $TMP_LIB $SYSTEM/lib 2>/dev/null;
    mv $TMP_LIB64 $SYSTEM/lib64 2>/dev/null;
    mv $TMP_SYSCONFIG $SYSTEM/etc/sysconfig 2>/dev/null;
    mv $TMP_DEFAULTPERMISSIONS $SYSTEM/etc/default-permissions 2>/dev/null;
    mv $TMP_PERMISSIONS $SYSTEM/etc/permissions 2>/dev/null;
    mv $TMP_PREFERREDAPPS $SYSTEM/etc/preferred-apps 2>/dev/null;
    mv $TMP_PROPFILE $S/etc 2>/dev/null;
    mv $TMP_BUILDFILE $S 2>/dev/null;
    mv $TMP_XBIN $S/xbin 2>/dev/null;
  ;;
  restore)
    # Stub
    opt_v29;
    opt_v30;
    on_whitelist_check;
    purge_whitelist_permission;
    set_whitelist_permission;
    set_assistant;
    cts_defaults;
    on_cts_status_check;
    cts_patch;
    sdk_fix;
    selinux_fix;
    bind_facelock_lib;
    sqlite_opt;
    restoredirTMPFboot;
    on_setup_status_check;
    trigger_fboot_restore;
    fix_setup_conflict;
    bind_setupwizard_lib;
    restoredirTMPRwg;
    on_rwg_status_check;
    trigger_rwg_restore;
  ;;
  post-restore)
    # Stub
    on_addon_status_check;
    fix_addon_conflict;
    restoredirTMPAddon;
    trigger_addon_restore;
    restore_conflicting_packages;
    rm -rf $S/app/ExtShared
    rm -rf $S/priv-app/ExtServices
    rm -rf $S/product/app/ExtShared
    rm -rf $S/product/priv-app/ExtServices
    rm -rf $S/system_ext/app/ExtShared
    rm -rf $S/system_ext/priv-app/ExtServices
    # Wipe temporary dir
    rm -rf $TMP/app
    rm -rf $TMP/bin
    rm -rf $TMP/priv-app
    rm -rf $TMP/framework
    rm -rf $TMP/lib
    rm -rf $TMP/lib64
    rm -rf $TMP/sysconfig
    rm -rf $TMP/default-permissions
    rm -rf $TMP/permissions
    rm -rf $TMP/preferred-apps
    rm -rf $TMP/etc
    rm -rf $TMP/xbin
    rm -rf $TMP/addon
    rm -rf $TMP/rwg
    rm -rf $TMP/fboot
    rm -rf $TMP/SYS_APP_CP
    rm -rf $TMP/SYS_PRIV_CP
    rm -rf $TMP/PRO_APP_CP
    rm -rf $TMP/PRO_PRIV_CP
    rm -rf $TMP/SYS_APP_EXT_CP
    rm -rf $TMP/SYS_PRIV_EXT_CP
    rm -rf $TMP/SYS_APP_CTT
    rm -rf $TMP/SYS_PRIV_CTT
    rm -rf $TMP/PRO_APP_CTT
    rm -rf $TMP/PRO_PRIV_CTT
    rm -rf $TMP/SYS_APP_EXT_CTT
    rm -rf $TMP/SYS_PRIV_EXT_CTT
    # Confirm that backup/restore is done
    conf_addon_backup;
  ;;
esac
