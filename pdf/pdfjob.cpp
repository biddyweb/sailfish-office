/*
 *
 */

#include "pdfjob.h"

#include <poppler-qt5.h>

LoadDocumentJob::LoadDocumentJob(const QString& source)
    : PDFJob{ PDFJob::LoadDocumentJob }, m_source{ source }
{

}

void LoadDocumentJob::run()
{
    m_document = Poppler::Document::load(m_source);
    m_document->setRenderHint( Poppler::Document::Antialiasing, true );
    m_document->setRenderHint( Poppler::Document::TextAntialiasing, true );
}

RenderPageJob::RenderPageJob(int index, uint width)
    : PDFJob{ PDFJob::RenderPageJob }, m_index{ index }, m_width{ width }
{

}

void RenderPageJob::run()
{
    Q_ASSERT(m_document);

    Poppler::Page* page = m_document->page( m_index );
    float scale = 72.0f * ( float(m_width) / page->pageSizeF().width() );
    m_page = page->renderToImage( scale, scale );
}

void PageSizesJob::run()
{
    Q_ASSERT(m_document);

    for( int i = 0; i < m_document->numPages(); ++i )
    {
        Poppler::Page* page = m_document->page( i );
        m_pageSizes.append( page->pageSizeF() );
    }
}
