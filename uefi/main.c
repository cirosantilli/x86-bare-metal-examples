#include <efi.h>
#include <efilib.h>

EFI_STATUS
EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable) {
   InitializeLib(ImageHandle, SystemTable);
   Print(L"Hello, world!\n");
   return EFI_SUCCESS;
}

/*
#include <efi.h>
#include <efilib.h>

EFI_STATUS efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable) {
  SIMPLE_TEXT_OUTPUT_INTERFACE *conout;
  InitializeLib(ImageHandle, SystemTable);
  conout = SystemTable->ConOut;
  uefi_call_wrapper(conout->OutputString, 2, conout, (CHAR16 *)L"Hello World\n\r");
  return EFI_SUCCESS;
}
*/
