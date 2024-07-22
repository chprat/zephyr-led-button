# Zephyr LED button example

This example is based on the
[Zephyr button example](https://github.com/zephyrproject-rtos/zephyr/tree/v3.6-branch/samples/basic/button),
but targets the
[Teensy 4.0 Development Board](https://www.pjrc.com/store/teensy40.html).

## Zephyr installation

Before we can start developing, we first need to set up the Zephyr development
tools. These instructions are based on the information found in the
[Zephyr Getting Started Guide](https://docs.zephyrproject.org/3.6.0/develop/getting_started/index.html).
More recent versions of the Zephyr SDK can be found
[here](https://github.com/zephyrproject-rtos/sdk-ng/releases).

### Install Ubuntu 22.04 dependencies

```
sudo apt update && sudo apt install --no-install-recommends git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1
```

### Install Zephyr SDK

```
export SDK_VERSION="0.16.8"
wget "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${SDK_VERSION}/zephyr-sdk-${SDK_VERSION}_linux-x86_64.tar.xz"
sudo tar xf "zephyr-sdk-${SDK_VERSION}_linux-x86_64.tar.xz" -C /opt
rm "zephyr-sdk-${SDK_VERSION}_linux-x86_64.tar.xz"
"/opt/zephyr-sdk-${SDK_VERSION}/setup.sh"
sudo cp "/opt/zephyr-sdk-${SDK_VERSION}/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules" /etc/udev/rules.d
sudo udevadm control --reload
```

### Install west

```
sudo apt update && sudo apt install --no-install-recommends python3-venv
python3 -m venv --upgrade-deps "$HOME/.local/bin/zephyr-venv"
. "$HOME/.local/bin/zephyr-venv/bin/activate"
python3 -m pip install west
```

### Setup project

```
git clone https://github.com/chprat/zephyr-led-button.git && cd zephyr-led-button
west init -l zephyr-led-button
west update
west zephyr-export
pip install -r zephyr/scripts/requirements.txt
```

### Install teensy flash tool

```
sudo apt update && sudo apt install --no-install-recommends libusb-dev
git clone https://github.com/PaulStoffregen/teensy_loader_cli "$HOME/.local/bin/teensy_loader_cli_repo"
pushd "$HOME/.local/bin/teensy_loader_cli_repo"
make
ln -s "$HOME/.local/bin/teensy_loader_cli_repo/teensy_loader_cli" "$HOME/.local/bin"
wget https://www.pjrc.com/teensy/00-teensy.rules
sudo cp 00-teensy.rules /etc/udev/rules.d
sudo udevadm control --reload
popd
```

## Build & flash the application

```
west build --board teensy40 --pristine always zephyr-led-button/
west flash
```

## Additional links

- [docker images](https://github.com/zephyrproject-rtos/docker-image)
- [external example application](https://github.com/zephyrproject-rtos/example-application/)
