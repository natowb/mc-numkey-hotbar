package net.minecraft.src;

import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.GL12;

public abstract class GuiContainer extends GuiScreen {
    private static RenderItem itemRenderer = new RenderItem();
    protected int xSize = 176;
    protected int ySize = 166;
    public Container inventorySlots;

    public GuiContainer(Container var1) {
        this.inventorySlots = var1;
    }

    public void initGui() {
        super.initGui();
        this.mc.thePlayer.craftingInventory = this.inventorySlots;
    }

    public void drawScreen(int var1, int var2, float var3) {
        this.drawDefaultBackground();
        int var4 = (this.width - this.xSize) / 2;
        int var5 = (this.height - this.ySize) / 2;
        this.drawGuiContainerBackgroundLayer(var3);
        GL11.glPushMatrix();
        GL11.glRotatef(120.0F, 1.0F, 0.0F, 0.0F);
        RenderHelper.enableStandardItemLighting();
        GL11.glPopMatrix();
        GL11.glPushMatrix();
        GL11.glTranslatef((float) var4, (float) var5, 0.0F);
        GL11.glColor4f(1.0F, 1.0F, 1.0F, 1.0F);
        GL11.glEnable(GL12.GL_RESCALE_NORMAL);
        Slot var6 = null;

        int var9;
        int var10;
        for (int var7 = 0; var7 < this.inventorySlots.slots.size(); ++var7) {
            Slot var8 = (Slot) this.inventorySlots.slots.get(var7);
            this.drawSlotInventory(var8);
            if (this.getIsMouseOverSlot(var8, var1, var2)) {
                var6 = var8;
                GL11.glDisable(GL11.GL_LIGHTING);
                GL11.glDisable(GL11.GL_DEPTH_TEST);
                var9 = var8.xDisplayPosition;
                var10 = var8.yDisplayPosition;
                this.drawGradientRect(var9, var10, var9 + 16, var10 + 16, -2130706433, -2130706433);
                GL11.glEnable(GL11.GL_LIGHTING);
                GL11.glEnable(GL11.GL_DEPTH_TEST);
            }
        }

        InventoryPlayer var12 = this.mc.thePlayer.inventory;
        if (var12.getItemStack() != null) {
            GL11.glTranslatef(0.0F, 0.0F, 32.0F);
            itemRenderer.renderItemIntoGUI(this.fontRenderer, this.mc.renderEngine, var12.getItemStack(), var1 - var4 - 8, var2 - var5 - 8);
            itemRenderer.renderItemOverlayIntoGUI(this.fontRenderer, this.mc.renderEngine, var12.getItemStack(), var1 - var4 - 8, var2 - var5 - 8);
        }

        GL11.glDisable(GL12.GL_RESCALE_NORMAL);
        RenderHelper.disableStandardItemLighting();
        GL11.glDisable(GL11.GL_LIGHTING);
        GL11.glDisable(GL11.GL_DEPTH_TEST);
        this.drawGuiContainerForegroundLayer();
        if (var12.getItemStack() == null && var6 != null && var6.getHasStack()) {
            String var13 = ("" + StringTranslate.getInstance().translateNamedKey(var6.getStack().getItemName())).trim();
            if (var13.length() > 0) {
                var9 = var1 - var4 + 12;
                var10 = var2 - var5 - 12;
                int var11 = this.fontRenderer.getStringWidth(var13);
                this.drawGradientRect(var9 - 3, var10 - 3, var9 + var11 + 3, var10 + 8 + 3, -1073741824, -1073741824);
                this.fontRenderer.drawStringWithShadow(var13, var9, var10, -1);
            }
        }

        GL11.glPopMatrix();
        super.drawScreen(var1, var2, var3);
        GL11.glEnable(GL11.GL_LIGHTING);
        GL11.glEnable(GL11.GL_DEPTH_TEST);
    }

    protected void drawGuiContainerForegroundLayer() {
    }

    protected abstract void drawGuiContainerBackgroundLayer(float var1);

    private void drawSlotInventory(Slot var1) {
        int var2 = var1.xDisplayPosition;
        int var3 = var1.yDisplayPosition;
        ItemStack var4 = var1.getStack();
        if (var4 == null) {
            int var5 = var1.getBackgroundIconIndex();
            if (var5 >= 0) {
                GL11.glDisable(GL11.GL_LIGHTING);
                this.mc.renderEngine.bindTexture(this.mc.renderEngine.getTexture("/gui/items.png"));
                this.drawTexturedModalRect(var2, var3, var5 % 16 * 16, var5 / 16 * 16, 16, 16);
                GL11.glEnable(GL11.GL_LIGHTING);
                return;
            }
        }

        itemRenderer.renderItemIntoGUI(this.fontRenderer, this.mc.renderEngine, var4, var2, var3);
        itemRenderer.renderItemOverlayIntoGUI(this.fontRenderer, this.mc.renderEngine, var4, var2, var3);
    }

    private Slot getSlotAtPosition(int var1, int var2) {
        for (int var3 = 0; var3 < this.inventorySlots.slots.size(); ++var3) {
            Slot var4 = (Slot) this.inventorySlots.slots.get(var3);
            if (this.getIsMouseOverSlot(var4, var1, var2)) {
                return var4;
            }
        }

        return null;
    }

    private boolean getIsMouseOverSlot(Slot var1, int var2, int var3) {
        int var4 = (this.width - this.xSize) / 2;
        int var5 = (this.height - this.ySize) / 2;
        var2 -= var4;
        var3 -= var5;
        return var2 >= var1.xDisplayPosition - 1 && var2 < var1.xDisplayPosition + 16 + 1 && var3 >= var1.yDisplayPosition - 1 && var3 < var1.yDisplayPosition + 16 + 1;
    }

    protected void mouseClicked(int var1, int var2, int var3) {
        super.mouseClicked(var1, var2, var3);
        if (var3 == 0 || var3 == 1) {
            Slot var4 = this.getSlotAtPosition(var1, var2);
            int var5 = (this.width - this.xSize) / 2;
            int var6 = (this.height - this.ySize) / 2;
            boolean var7 = var1 < var5 || var2 < var6 || var1 >= var5 + this.xSize || var2 >= var6 + this.ySize;
            int var8 = -1;
            if (var4 != null) {
                var8 = var4.slotNumber;
            }

            if (var7) {
                var8 = -999;
            }

            if (var8 != -1) {
                boolean var9 = var8 != -999 && (Keyboard.isKeyDown(Keyboard.KEY_LSHIFT) || Keyboard.isKeyDown(Keyboard.KEY_RSHIFT));
                this.mc.playerController.func_27174_a(this.inventorySlots.windowId, var8, var3, var9, this.mc.thePlayer);
            }
        }

    }

    protected void mouseMovedOrUp(int var1, int var2, int var3) {
        if (var3 == 0) {
        }

    }

    protected void keyTyped(char var1, int var2) {
        if (var2 == 1 || var2 == this.mc.gameSettings.keyBindInventory.keyCode) {
            this.mc.thePlayer.closeScreen();
        }

        int mouseX = Mouse.getEventX() * this.width / this.mc.displayWidth;
        int mouseY = this.height - Mouse.getEventY() * this.height / this.mc.displayHeight - 1;


        Slot hoveredSlot = this.getSlotAtPosition(mouseX, mouseY);

        if (hoveredSlot == null) {
            return;
        }

        int slotNumber = -1;

        int length = this.inventorySlots.slots.size();

        switch (var2) {
            case Keyboard.KEY_1:
                slotNumber = length - 9;
                break;
            case Keyboard.KEY_2:
                slotNumber = length - 8;
                break;
            case Keyboard.KEY_3:
                slotNumber = length - 7;
                break;
            case Keyboard.KEY_4:
                slotNumber = length - 6;
                break;
            case Keyboard.KEY_5:
                slotNumber = length - 5;
                break;
            case Keyboard.KEY_6:
                slotNumber = length - 4;
                break;
            case Keyboard.KEY_7:
                slotNumber = length - 3;
                break;
            case Keyboard.KEY_8:
                slotNumber = length - 2;
                break;
            case Keyboard.KEY_9:
                slotNumber = length - 1;
                break;
        }


        if (slotNumber == -1) {
            return;
        }

        if (hoveredSlot.slotNumber == slotNumber) {
            return;
        }

        Slot hotbarSlot = this.inventorySlots.getSlot(slotNumber);


        if (hoveredSlot.getHasStack()) {
            this.mc.playerController.func_27174_a(this.inventorySlots.windowId, hoveredSlot.slotNumber, 0, false, this.mc.thePlayer);
        }


        if (hotbarSlot.getHasStack()) {
            if (hoveredSlot.isItemValid(hotbarSlot.getStack())) {
                this.mc.playerController.func_27174_a(this.inventorySlots.windowId, slotNumber, 0, false, this.mc.thePlayer);
                this.mc.playerController.func_27174_a(this.inventorySlots.windowId, hoveredSlot.slotNumber, 0, false, this.mc.thePlayer);
            } else {
                this.mc.playerController.func_27174_a(this.inventorySlots.windowId, hoveredSlot.slotNumber, 0, false, this.mc.thePlayer);
            }
        } else {
            this.mc.playerController.func_27174_a(this.inventorySlots.windowId, slotNumber, 0, false, this.mc.thePlayer);
        }

    }

    public void onGuiClosed() {
        if (this.mc.thePlayer != null) {
            this.mc.playerController.func_20086_a(this.inventorySlots.windowId, this.mc.thePlayer);
        }
    }

    public boolean doesGuiPauseGame() {
        return false;
    }

    public void updateScreen() {
        super.updateScreen();
        if (!this.mc.thePlayer.isEntityAlive() || this.mc.thePlayer.isDead) {
            this.mc.thePlayer.closeScreen();
        }

    }
}
