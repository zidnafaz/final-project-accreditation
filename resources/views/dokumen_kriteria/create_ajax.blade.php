<form id="formCreateDokumenPendukung" method="POST" action="{{ route('dokumen_kriteria.store_ajax') }}" enctype="multipart/form-data">
    @csrf
    <input type="hidden" name="no_kriteria" value="{{ $no_kriteria ?? '' }}">
    <input type="hidden" name="kategori" value="{{ $kategori ?? '' }}">
    <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">Tambah Dokumen Pendukung</h5>
        <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
    </div>
    <div class="modal-body">
        <div class="mb-3">
            <label for="nama_file" class="form-label">Nama File</label>
            <input type="text" class="form-control" id="nama_file" name="nama_file" required>
            <div class="invalid-feedback" id="error_nama_file"></div>
        </div>
        <div class="mb-3">
            <label for="Keterangan" class="form-label">Keterangan</label>
            <input type="text" class="form-control" id="Keterangan" name="Keterangan" required>
            <div class="invalid-feedback" id="error_Keterangan"></div>
        </div>
        <div class="mb-3">
            <label for="dokumen_pendukung" class="form-label">Dokumen Pendukung (PDF, JPG, PNG)</label>
            <div class="input-group">
                <div class="input-group-prepend">
                    <label for="dokumen_pendukung" class="btn btn-info mb-0">Choose File</label>
                </div>
                <input type="file" class="form-control d-none" id="dokumen_pendukung" name="dokumen_pendukung"
                    accept=".pdf,.jpg,.jpeg,.png"
                    onchange="document.getElementById('dokumen_pendukung_text').value = this.files[0]?.name || 'No file chosen'">
                <input type="text" class="form-control" id="dokumen_pendukung_text" placeholder="No file chosen" readonly>
                <div id="error_dokumen_pendukung" class="invalid-feedback"></div>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fas fa-times me-1"></i> Batal</button>
        <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i> Simpan</button>
    </div>
</form>
