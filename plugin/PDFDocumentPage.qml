/*
 * Copyright (C) 2013-2014 Jolla Ltd.
 * Contact: Robin Burchell <robin.burchell@jolla.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2 only.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Office.PDF 1.0 as PDF
import org.nemomobile.notifications 1.0

DocumentPage {
    id: base;

    attachedPage: Component {
        PDFDocumentToCPage {
            tocModel: pdfDocument.tocModel
            onPageSelected: view.goToPage( pageNumber );
        }
    }

    PDFView {
        id: view;

        width: base.width;
        height: base.height;

        document: pdfDocument;

        onClicked: base.open = !base.open;
    }

    PDF.Document {
        id: pdfDocument;
        source: base.path;
        onDocumentLoaded: if (failure) {
            pageStack.completeAnimation();
            pageStack.pop();
            notification.publish();
        }
    }

    busy: !pdfDocument.loaded;
    source: pdfDocument.source;
    indexCount: pdfDocument.pageCount;

    Timer {
        id: updateSourceSizeTimer;
        interval: 5000;
        onTriggered: linkArea.sourceSize = Qt.size( base.width, pdfCanvas.height );
    }

    Notification {
        id: notification;
        //% "Cannot open PDF file"
        previewBody: qsTrId("sailfish-office-me-broken-pdf-desc");
        //% "Broken file"
        previewSummary: qsTrId("sailfish-office-me-broken-pdf-summary");
    }    
}
