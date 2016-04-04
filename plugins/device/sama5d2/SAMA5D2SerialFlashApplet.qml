import QtQuick 2.3
import SAMBA 3.1

/*! \internal */
Applet {
	name: "serialflash"
	description: "AT25/AT26 Serial Flash"
	codeUrl: Qt.resolvedUrl("applets/applet-serialflash-sama5d2.bin")
	codeAddr: 0x220000
	mailboxAddr: 0x220004
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31; timeout:1000 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 }
	]

	/*! \internal */
	function buildInitArgs(connection, device) {
		if (typeof device.config.spiInstance === "undefined")
			throw new Error("Incomplete configuration, missing value for spiInstance")

		if (typeof device.config.spiIoset === "undefined")
			throw new Error("Incomplete configuration, missing value for spiIoset")

		if (typeof device.config.spiChipSelect === "undefined")
			throw new Error("Incomplete configuration, missing value for spiChipSelect")

		if (typeof device.config.spiFreq === "undefined")
			throw new Error("Incomplete configuration, missing value for spiFreq")

		var args = defaultInitArgs(connection, device)
		var config = [ device.config.spiInstance,
		               device.config.spiIoset,
		               device.config.spiChipSelect,
		               Math.floor(device.config.spiFreq * 1000000) ]
		Array.prototype.push.apply(args, config)
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(device, args)	{
		switch (args.length)
		{
		case 4:
			if (args[3].length > 0) {
				device.config.spiFreq = Number(args[3]);
				if (isNaN(device.config.spiFreq))
					return "Invalid SPI frequency (not a number)."
			}
			// fall-through
		case 3:
			if (args[2].length > 0) {
				device.config.spiChipSelect = Number(args[2]);
				if (isNaN(device.config.spiChipSelect))
					return "Invalid SPI chip select (not a number)."
			}
			// fall-through
		case 2:
			if (args[1].length > 0) {
				device.config.spiIoset = Number(args[1]);
				if (isNaN(device.config.spiIoset))
					return "Invalid SPI ioset (not a number)."
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				device.config.spiInstance = Number(args[0]);
				if (isNaN(device.config.spiInstance))
					return "Invalid SPI instance (not a number)."
			}
			// fall-through
		case 0:
			return true;
		default:
			return "Invalid number of arguments."
		}
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: serialflash:[<instance>]:[<ioset>]:[<npcs>]:[<frequency>]",
				"Examples: serialflash -> SPI serialflash applet using default board settings",
				"          serialflash:0:1:0:66 -> SPI serialflash applet using fully custom settings (SPI0, IOSET1, NPCS0, 66Mhz)",
				"          serialflash::::20 -> SPI serialflash applet using default board settings but frequency set to 20Mhz"]
	}
}