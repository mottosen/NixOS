{ lib, ... }:

{
  options = {
    systemSettings = {
      profile = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "not-set";
      };

      architecture = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "not-set";
      };

      kernel = lib.mkOption {
        type = lib.types.anything;
        default = "";
      };

      hostname = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "not-set";
      };

      timezone = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "not-set";
      };

      locale = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "en_US.UTF-8";
      };

      bootMountPath = lib.mkOption {
        type = lib.types.path;
        default = "/boot";
      };

      bootloader = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "efi";
      };

      systemDevice = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "not-set";
      };
    };
  };
}
