/*
 * Copyright (c) 2016, Atmel Corporation.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

import QtQuick 2.3
import SAMBA 3.1

/*! \internal */
Applet {
	name: "lowlevel"
	description: "Low-Level"
	codeUrl: Qt.resolvedUrl("applets/applet-lowlevelinit-at91sam9260.bin")
	codeAddr: 0x200000
	mailboxAddr: 0x200004
	commands: [
		AppletCommand { name:"legacyInitialize"; code:0 }
	]

	/*! \internal */
	function buildInitArgs(connection, device) {
		var args = defaultInitArgs(connection, device)
		Array.prototype.push.apply(args, [0, 0, 0])
		return args
	}
}
