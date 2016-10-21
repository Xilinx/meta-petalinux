/****************************************************************************
 * **
 * ** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
 * ** Contact: http://www.qt-project.org/legal
 * **
 * ** This file is part of the qmake spec of the Qt Toolkit.
 * **
 * ** $QT_BEGIN_LICENSE:LGPL21$
 * ** Commercial License Usage
 * ** Licensees holding valid commercial Qt licenses may use this file in
 * ** accordance with the commercial license agreement provided with the
 * ** Software or, alternatively, in accordance with the terms contained in
 * ** a written agreement between you and Digia. For licensing terms and
 * ** conditions see http://qt.digia.com/licensing. For further information
 * ** use the contact form at http://qt.digia.com/contact-us.
 * **
 * ** GNU Lesser General Public License Usage
 * ** Alternatively, this file may be used under the terms of the GNU Lesser
 * ** General Public License version 2.1 or version 3 as published by the Free
 * ** Software Foundation and appearing in the file LICENSE.LGPLv21 and
 * ** LICENSE.LGPLv3 included in the packaging of this file. Please review the
 * ** following information to ensure the GNU Lesser General Public License
 * ** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
 * ** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
 * **
 * ** In addition, as a special exception, Digia gives you certain additional
 * ** rights. These rights are described in the Digia Qt LGPL Exception
 * ** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
 * **
 * ** $QT_END_LICENSE$
 * **
 * ****************************************************************************/

#include "qeglfshooks.h"
#include <fcntl.h>
#include <linux/fb.h>
#include <sys/ioctl.h>
#include <unistd.h>

QT_BEGIN_NAMESPACE

typedef struct fbdev_window
{
	unsigned short width;
	unsigned short height;
} fbdev_window;

class QEglFSZynqMPHooks : public QEglFSHooks
{
	public:
		virtual QSize screenSize() const;
		virtual EGLNativeWindowType createNativeWindow(QPlatformWindow *window, const QSize &size, const QSurfaceFormat &format);
		virtual void destroyNativeWindow(EGLNativeWindowType window);
};

QSize QEglFSZynqMPHooks::screenSize() const
{
	int fd = open("/dev/fb0", O_RDONLY);
	if (fd == -1) {
		qFatal("Failed to open fb to detect screen resolution!");
	}

	struct fb_var_screeninfo vinfo;
	if (ioctl(fd, FBIOGET_VSCREENINFO, &vinfo) == -1) {
		qFatal("Could not get variable screen info");
	}

	close(fd);

	return QSize(vinfo.xres, vinfo.yres);
}

EGLNativeWindowType QEglFSZynqMPHooks::createNativeWindow(QPlatformWindow *window, const QSize &size, const QSurfaceFormat &format)
{
	Q_UNUSED(window);
	Q_UNUSED(format);

	fbdev_window *fbwin = new fbdev_window;
	fbwin->width = size.width();
	fbwin->height = size.height();

	return (EGLNativeWindowType)fbwin;
}

void QEglFSZynqMPHooks::destroyNativeWindow(EGLNativeWindowType window)
{
	delete (struct fbdev_window*) window;
}


QEglFSZynqMPHooks eglFSZynqMPHooks;
QEglFSHooks *platformHooks = &eglFSZynqMPHooks;

QT_END_NAMESPACE
